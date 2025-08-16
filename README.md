# cloudnative-observability-infra

![status](https://img.shields.io/badge/status-WIP-yellow)
[![lint](https://github.com/shtsukada/cloudnative-observability-infra/actions/workflows/lint.yml/badge.svg?branch=main)](https://github.com/shtsukada/cloudnative-observability-infra/actions/workflows/lint.yml)
[![license](https://img.shields.io/github/license/shtsukada/cloudnative-observability-infra)](./LICENSE)
![Terraform](https://img.shields.io/badge/Terraform-1.9%2B-blue)
![Helm](https://img.shields.io/badge/Helm-3.12%2B-blue)

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
