# Wordpress AKS Cluster
Deploy a WordPress site and a MySQL database using Azure AKS. Both applications use PersistentVolumes and PersistentVolumeClaims to store data.

## Provision an azure aks cluster
1. Create an Active Directory service principal account
    ```bash
    az ad sp create-for-rbac --skip-assignment
    ```

2. Put the generated `appId` and `password` at the terraform variables

3. Provision the infrastructure using terraform
    ```bash
    cd terraform
    terraform init
    terraform apply
    ```

4. Configure `kubectl`
    ```bash
    az aks get-credentials --resource-group $(terraform output -raw resource_group_name) --name $(terraform output -raw kubernetes_cluster_name)
    ```

6. Install Ingress
    ```bash
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.10.4/deploy/static/provider/cloud/deploy.yaml
    ```

7. Get the loadbalancer IP address to be used in Cloudflare
    ```bash
    kubectl get svc -n ingress-nginx
    ```

8. Install argocd
    ```bash
    kubectl create namespace argocd
    kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
    ```

9. Setup argocd
    ```bash
    kubectl apply -f argocd/ingress.yml
    ```

10. Create the `tls-secret` using one of the follwing methods:
    ```bash
    kubectl create -n argocd secret tls argocd-server-tls --cert=path/to/cert.pem --key=/path/to/key.pem
    ```
    or run ``kubectl apply -f argocd/tls-secret.yml`` on this file
    ```yml
    apiVersion: v1
    kind: Secret
    metadata:
      name: tls-secret
      namespace: argocd
    type: kubernetes.io/tls
    data:
      tls.crt: <base64-of-tls.crt>
      tls.key: <base64-of-tls.key>
    ```

11. Create an `A` record on Cloudflare such that saeed-argocd points at the loadbalancer IP address

12. Now argocd should open at https://saeed-argocd.cloud-stacks.com

13. Find the initial admin password using:
    ```bash
    argocd admin initial-password -n argocd
    ```

14. Configure argocd to connect to this repository

15. Create another `tls-secret` at the `dev` namespace
    ```yml
    apiVersion: v1
    kind: Secret
    metadata:
      name: tls-secret
      namespace: dev
    type: kubernetes.io/tls
    data:
      tls.crt: <base64-of-tls.crt>
      tls.key: <base64-of-tls.key>
    ```

16. Create an application that points at the path `overlays/dev`

17. Now you could open the wordpress application at https://saeed-wordpress.cloud-stacks.com
