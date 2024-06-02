# Wordpress EKS Cluster
deploy a WordPress site and a MySQL database using AWS EKS. Both applications use PersistentVolumes and PersistentVolumeClaims to store data.

## Prerequisites
- AWS CLI
- kubectl

## Usage
- Apply the kustomization directory by
  ```bash
  kubectl apply -k ./
  ```
- Run the following command to get the IP Address for the WordPress Service:
  ```bash
  kubectl get svc wordpress
  ```
- Run the following command to delete your Secret, Deployments, Services and PersistentVolumeClaims:
  ```bash
  kubectl delete -k ./
  ```