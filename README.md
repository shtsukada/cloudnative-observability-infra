# cloudnative-observability-infra

EKS/Terraform + GitOps ブートストラップ環境を提供するリポジトリです。

## 成果物

- Terraform による VPC/EKS/IAM/IRSA 基盤
- Argo CD (bootstrap, AppProject, app-of-apps)
- Namespace: argocd / monitoring / grpc-app
- Sealed Secrets

## 契約

- Terraform v1.9 / AWS provider ~>5 / EKS v1.29
- Argo CD は app-of-apps で下流4リポを参照
- Secret 名は contracts.md に準拠
- 詳細はルートリポ [contracts.md](../cloudnative-observability/docs/contracts.md) を参照

## Quickstart

```bash
terraform init
terraform plan
terraform apply
```

## MVP

- VPC/EKS/IRSA
- Argo CD bootstrap
- Namespaces
- Sealed Secrets
- AppProject + app-of-apps
- CI: plan/apply(dev)

## Plus

- Argo CD Notifications → Slack
- Renovate
- PodSecurity (restricted) + 最小 NetworkPolicy

## 受け入れ基準チェックリスト

- [ ] terraform apply でクラスタが起動
- [ ] `kubectl get ns` で argocd/monitoring/grpc-app が作成
- [ ] `argocd app list` で app-of-apps が Sync 状態

## スコープ外

- アプリ/監視スタックの中身
- Rollout/HPA チューニング
- データベース/外部マネージドサービス

## ライセンス

MIT License
