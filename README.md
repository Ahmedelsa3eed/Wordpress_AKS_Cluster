# Wordpress EKS Cluster
Deploy a WordPress site and a MySQL database using AWS EKS. Both applications use PersistentVolumes and PersistentVolumeClaims to store data.

## Before you begin
You need to have a Kubernetes cluster, and the kubectl command-line tool must be configured to communicate with your cluster.
- AWS CLI
- kubectl
- You will need to run the following command to configure kubeconfig:
  ```bash
  aws eks --region <region> update-kubeconfig --name <cluster_name>
  ```
- Amazon EBS CSI Driver

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