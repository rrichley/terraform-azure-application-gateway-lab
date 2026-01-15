# Terraform Azure Application Gateway Lab

## Overview

This project deploys an **Azure Application Gateway** using **Terraform**, with two backend virtual machines running **NGINX**. The Application Gateway load-balances HTTP traffic between the backend VMs.

This is a **simple lab** designed for learning and portfolio use.

---

## What This Deploys

* Azure Resource Group
* Virtual Network (10.0.0.0/16)

  * `AGSubnet` – Application Gateway subnet
  * `BackendSubnet` – Backend VM subnet
* Application Gateway (Standard_v2)

  * Public IP
  * HTTP listener on port 80
  * Backend pool using VM private IPs
* Two Linux virtual machines (Ubuntu)

  * NGINX installed via VM extension

---

## How to Deploy

```bash
terraform init
terraform apply
```

---

## Test

1. Copy the **Application Gateway public IP** from the Azure Portal.
2. Paste it into a browser.
3. Refresh the page.

You should see the response alternate between:

```
BackendVM1
BackendVM2
```

---

## Cleanup

```bash
terraform destroy
```

---

## Notes

* Backend VMs do not have public IPs.
* This project is for lab
