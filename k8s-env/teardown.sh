#!/bin/sh

KUBERNETES_VAULT_DEPLOYMENT="kubernetes-vault.yaml"

if [ "$KUBE_1_5" = true ]; then
    KUBERNETES_VAULT_DEPLOYMENT="kubernetes-vault-kube-1.5.yaml"
fi

# Prepare PersistenVolume and PersistenVolumeClaim
PERSISTENT_VOLUME="dummy-prj-pv-volume.yaml"
PERSISTENT_VOLUME_CLAIM="dummy-prj-pv-claim.yaml"

SAMPLE_APP_DEPLOYMENT="sample-app.yaml"

if [ "$KUBE_1_5" = true ]; then
    SAMPLE_APP_DEPLOYMENT="sample-app-kube-1.5.yaml"
fi

kubectl delete -f "$SAMPLE_APP_DEPLOYMENT" -f "$PERSISTENT_VOLUME_CLAIM" -f "$PERSISTENT_VOLUME" -f "$KUBERNETES_VAULT_DEPLOYMENT" -f vault.yaml
pid=$(pgrep -f "kubectl port-forward" | grep 8200)
if [ ! -z "$pid" ]; then
    kill "$pid"
fi
rm -f nohup.out
