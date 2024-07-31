// vars/eksConfig.groovy
def save(region, clusterName) {
  sh """
    AWS_ACCESS_KEY_ID=${env.AWS_ACCESS_KEY_ID} \\
    AWS_SECRET_ACCESS_KEY=${env.AWS_SECRET_ACCESS_KEY} \\
    aws eks update-kubeconfig --region ${region} --name ${clusterName} --kubeconfig kubeconfig_${clusterName}
  """
  env.KUBECONFIG = "${WORKSPACE}/kubeconfig_${clusterName}"
}

def use() {
  env.KUBECONFIG = "${WORKSPACE}/kubeconfig_${env.CLUSTER_NAME}"
  println "Using kubeconfig: ${env.KUBECONFIG}"
}
