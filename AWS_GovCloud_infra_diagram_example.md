flowchart TB
  subgraph GOVCLOUD["AWS GovCloud (US)"]
    direction TB

    subgraph Accounts["Account Boundary"]
      direction LR
      MGMT[Management Account]
      PROD[Prod IL5 Account]
      LOGS[Logging & SIEM Account]
    end

    subgraph VPC_PROD["VPC: Prod-IL5 (Private)"]
      direction TB
      APP_SUBNETS[Private App Subnets]
      DB_SUBNETS[Private DB Subnets]
      MGMT_SUBNET["Management Subnet (bastion/SSM)"]
    end

    MGMT -->|SCP / Guardrails| PROD
    LOGS -->|S3 archive / SIEM| PROD

    APP_SUBNETS -->|connects| DB_SUBNETS
    MGMT_SUBNET -->|SSM/Bastion| APP_SUBNETS

    CloudTrail[(CloudTrail)]
    KMS[(Customer KMS CMK - FIPS validated)]
    S3_LOGS[(S3 - Encrypted Audit Bucket)]
    FLOWLOGS[(VPC Flow Logs -> Kinesis -> S3 / SIEM)]
    CONFIG[(AWS Config / SecurityHub / GuardDuty)]

    PROD --> VPC_PROD
    CloudTrail --> S3_LOGS
    KMS -. encrypts .-> S3_LOGS
    FLOWLOGS --> S3_LOGS
    CONFIG --> LOGS

    CI_CD["GitLab / Jenkins (pipeline)"]
    CI_CD -->|"Deploys via assume-role (least-privilege)"| PROD

    EKS_NOTE[["Optional: EKS (GovCloud) with Pod Network Policies, OPA Gatekeeper, image scanning"]]
    APP_SUBNETS --> EKS_NOTE
  end
