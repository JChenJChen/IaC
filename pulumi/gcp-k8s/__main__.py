import pulumi
import pulumi_gcp as gcp

# Get some provider-namespaced configuration values
provider_cfg = pulumi.Config("gcp")
gcp_project = provider_cfg.require("project")
gcp_region = provider_cfg.get("region", "us-central1")
# Get some additional configuration values
config = pulumi.Config()
nodes_per_zone = config.get_int("nodesPerZone", 1)

# # enable GCP APIs
# apis_to_enable = [
#     "compute.googleapis.com",
#     "devstorage.googleapis.com",
#     "logging.googleapis.com",
#     "monitoring.googleapis.com",
#     "cloud-platform.googleapis.com",
#     "container.googleapis.com",
#     "cloudresourcemanager.googleapis.com",
#     "serviceusage.googleapis.com", # Service Usage API is often required for managing other services
# ]
# for api_name in apis_to_enable:
#     gcp.projects.Service(
#         f"enable-{api_name.replace('.', '-')}",  # Unique name for the resource
#         project=gcp_project,
#         service=api_name,
#         disable_on_destroy=False  # Set to True if you want to disable the API on `pulumi destroy`
#     )

# Create a new network
gke_network = gcp.compute.Network(
    "gke-vpc",
    auto_create_subnetworks=False,
    description=" GKE VPC Network"
)

# Create a subnet in the new network
gke_subnet = gcp.compute.Subnetwork(
    "gke-subnet",
    ip_cidr_range="10.128.0.0/9",
    network=gke_network.id,
    private_ip_google_access=True
)

# Create a cluster in the new network and subnet
gke_cluster = gcp.container.Cluster(
    "gke-cluster",
    addons_config={
        "dns_cache_config": {
            "enabled": True
        },
    },
    binary_authorization={
        "evaluation_mode": "PROJECT_SINGLETON_POLICY_ENFORCE"
    },
    datapath_provider="ADVANCED_DATAPATH",
    deletion_protection=False,
    description="A GKE cluster",
    initial_node_count=1,
    ip_allocation_policy={
        "cluster_ipv4_cidr_block": "/14",
        "services_ipv4_cidr_block": "/20"
    },
    location=gcp_region,
    master_authorized_networks_config={
        "cidr_blocks": [{
            "cidr_block": "0.0.0.0/0",
            "display_name": "All networks"
        }]
    },
    network=gke_network.name,
    networking_mode="VPC_NATIVE",
    private_cluster_config={
        "enable_private_nodes": True,
        "enable_private_endpoint": False,
        "master_ipv4_cidr_block": "10.100.0.0/28"
    },
    remove_default_node_pool=True,
    release_channel={
        "channel": "STABLE"
    },
    subnetwork=gke_subnet.name,
    workload_identity_config={
        "workload_pool": f"{gcp_project}.svc.id.goog"
    }
)

# Create a GCP service account for the nodepool
gke_nodepool_sa = gcp.serviceaccount.Account(
    "gke-nodepool-sa",
    account_id=pulumi.Output.concat(gke_cluster.name, "-np-1-sa"),
    display_name="Nodepool 1 Service Account"
)

# Create a nodepool for the cluster
gke_nodepool = gcp.container.NodePool(
    "gke-nodepool",
    name = "gke-nodepool",
    location = "us-east4",
    cluster=gke_cluster.id,
    node_count=nodes_per_zone,
    node_config={
        "oauth_scopes": [
            "https://www.googleapis.com/auth/cloud-platform",
            "https://www.googleapis.com/auth/compute",
            "https://www.googleapis.com/auth/devstorage.read_only",
            "https://www.googleapis.com/auth/logging.write",
            "https://www.googleapis.com/auth/monitoring",
            ],
        "service_account": gke_nodepool_sa.email
    },
    # Set the Nodepool Autoscaling configuration
    autoscaling = gcp.container.NodePoolAutoscalingArgs(
        min_node_count = 1,
        max_node_count = 2
    ),
    # Set the Nodepool Management configuration
    management = gcp.container.NodePoolManagementArgs(
        auto_repair  = True,
        auto_upgrade = True
    )
)
# # REF SRC: https://blog.devops.dev/creating-a-gke-cluster-using-pulumi-python-7662983c0b83
# # Defining the GKE Node Pool
# gke_nodepool = gcp.container.NodePool("nodepool-1",
#     name = "nodepool-1",
#     location = "us-central1",
#     node_locations = ["us-central1-a"],
#     cluster = gke_cluster.id,
#     node_count = NODE_COUNT,
#     node_config = gcp.container.NodePoolNodeConfigArgs(
#         preemptible = False,
#         machine_type = NODE_MACHINE_TYPE,
#         disk_size_gb = 20,
#         oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"],
#         shielded_instance_config = gcp.container.NodePoolNodeConfigShieldedInstanceConfigArgs(
#             enable_integrity_monitoring = True,
#             enable_secure_boot = True
#         )
#     )
# )

# Build a Kubeconfig to access the cluster
cluster_kubeconfig = pulumi.Output.all(
    gke_cluster.master_auth.cluster_ca_certificate,
    gke_cluster.endpoint,
    gke_cluster.name).apply(lambda l:
    f"""apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: {l[0]}
    server: https://{l[1]}
  name: {l[2]}
contexts:
- context:
    cluster: {l[2]}
    user: {l[2]}
  name: {l[2]}
current-context: {l[2]}
kind: Config
preferences: {{}}
users:
- name: {l[2]}
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1beta1
      command: gke-gcloud-auth-plugin
      installHint: Install gke-gcloud-auth-plugin for use with kubectl by following
        https://cloud.google.com/blog/products/containers-kubernetes/kubectl-auth-changes-in-gke
      provideClusterInfo: true
""")

# Export some values for use elsewhere
pulumi.export("networkName", gke_network.name)
pulumi.export("networkId", gke_network.id)
pulumi.export("clusterName", gke_cluster.name)
pulumi.export("clusterId", gke_cluster.id)
pulumi.export("kubeconfig", cluster_kubeconfig)
