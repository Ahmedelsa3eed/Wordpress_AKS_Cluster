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
- Install Amazon EBS CSI Driver
- Install Metrics Server
  ```bash
  kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
  ```
- Add the certficate and key to secrets:
  ```bash
  kubectl create secret tls wordpress-tls --key cert/key.pem --cert cert/cert.pem
  ```

## Usage
- Apply the kustomization directory by
  ```bash
  kubectl apply -k ./
  ```
- Run the following command to verify that the Ingress resource has been created:
  ```bash
  kubectl get ing
  ```
- Run the following command to delete your Secret, Deployments, Services and PersistentVolumeClaims:
  ```bash
  kubectl delete -k ./
  ```