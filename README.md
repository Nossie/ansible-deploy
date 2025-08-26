# Ansible Deploy Automation

This repository provides a modular and automated solution for deploying, decommissioning, and managing virtual machines (VMs) in a vCenter environment using Ansible. It integrates with Infoblox for IP and DNS management and supports interactive deployment workflows via Azure DevOps pipelines.

---

## 🚀 Features

- Deploy VMs from templates via vCenter
- Reserve and release IP addresses and DNS entries using Infoblox
- Join VMs to a domain (optional)
- Decommission and clean up obsolete VMs
- Interactive deployment wizard with dropdown menus
- Modular discovery pipelines for dynamic parameter generation

---

## 📁 Repository Structure

```
.
├── pipelines/                  # Azure DevOps pipeline templates
│   ├── deploy-wizard.yml       # Main interactive deployment wizard
│   ├── discover-*.yml          # Discovery templates for playbooks, OS, VLANs, clusters
│   ├── discover-full.yml       # Runs all discovery templates
│   └── discover-menu.yml       # Controller pipeline to select discovery target
├── playbooks/                 # Ansible playbooks
│   ├── deploy-vm.yml           # Deploy VM from template
│   ├── decommission-vm.yml     # Tag and power off VM
│   ├── cleanup-vms.yml         # Remove obsolete VMs and release IP/DNS
│   └── run-playbook.yml        # Dynamically run selected playbook
├── roles/                     # Ansible roles
│   ├── infoblox_reserve_ip/    # Reserve IP in Infoblox
│   ├── vm_cleanup/             # Release IP/DNS and delete VM
│   └── domain_join/            # Join VM to domain
├── group_vars/
│   └── all/
│       └── vault.yml           # Encrypted secrets
└── README.md
```

---

## 🧩 Pipelines Overview

### `deploy-wizard.yml`
Interactive pipeline that:
- Optionally refreshes dropdowns via discovery
- Supports actions: New Deployment, Run Playbook, Decommission, Cleanup
- Uses dropdowns populated by discovery pipelines

### `discover-menu.yml`
Selectively runs discovery templates to populate dropdowns:
- Playbooks
- OS templates
- VLANs
- Clusters

### `discover-full.yml`
Runs all discovery templates sequentially.

### Discovery Templates (`discover-*.yml`)
Each template generates a `pipeline-parameters.yml` file with dropdown values and publishes it as an artifact.

---

## 📜 Playbooks Overview

### `deploy-vm.yml`
- Reserves IP via Infoblox
- Clones VM from template
- Adds disks
- Optionally joins domain

### `decommission-vm.yml`
- Powers off VM
- Tags VM for removal

### `cleanup-vms.yml`
- Finds tagged VMs older than 7 days
- Releases IP and DNS
- Deletes VM

### `run-playbook.yml`
- Dynamically runs a task-based playbook

---

## 🌐 Infoblox Integration

Ensure the following roles are configured:
- `infoblox_reserve_ip`: Reserves IP and DNS
- `vm_cleanup`: Releases IP and DNS, deletes VM

These roles use Infoblox REST API with credentials stored in `vault.yml`.

---

## ⚙️ Requirements

- Ansible 2.10+
- Python modules: `requests`, `community.vmware`, `community.general`
- Access to vCenter and Infoblox
- Azure DevOps pipeline agent (Ubuntu recommended)

---

## 📦 Azure DevOps Setup

Add the following pipelines to Azure DevOps:

1. `deploy-wizard.yml` — Main interactive pipeline
2. `discover-menu.yml` — Discovery controller pipeline
3. `discover-full.yml` — Full discovery pipeline

Ensure the repo is connected and accessible by the pipeline agent.

---

## 📌 Usage

1. Configure secrets in `group_vars/all/vault.yml`
2. Run `deploy-wizard.yml` pipeline in Azure DevOps
3. Select desired action and parameters via dropdowns
4. Monitor deployment or cleanup progress
