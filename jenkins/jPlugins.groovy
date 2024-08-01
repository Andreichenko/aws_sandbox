import jenkins.model.Jenkins
import jenkins.model.Jenkins.*
import hudson.model.UpdateCenter
import hudson.model.UpdateSite.Plugin
import hudson.util.VersionNumber

def pluginList = [
  'workflow-aggregator:2.6',
  'git:4.9.0',
  'credentials:2.6.1',
  'credentials-binding:1.27',
  'pipeline-aws:1.43',
  'terraform:1.0.11'
]

def updateCenter = Jenkins.instance.updateCenter

pluginList.each { pluginSpec ->
  def (pluginId, pluginVersion) = pluginSpec.split(':')
  def installedPlugin = Jenkins.instance.pluginManager.getPlugin(pluginId)
  if (!installedPlugin || (installedPlugin && new VersionNumber(installedPlugin.getVersion()).isOlderThan(new VersionNumber(pluginVersion)))) {
    println "Installing/updating plugin ${pluginId} ${pluginVersion}"
    def plugin = updateCenter.getPlugin(pluginId).deploy(true)
    plugin.get().getRequiredDependencies().each { dependency ->
      println "Installing/updating dependency ${dependency.name}:${dependency.version}"
      updateCenter.getPlugin(dependency.name).deploy(true)
    }
  } else {
    println "Plugin ${pluginId} is already installed and up to date."
  }
}


//java -jar jenkins-cli.jar -s http://our-jenkins-url -auth username:password groovy install_plugin.groovy
//java -jar jenkins-cli.jar -s http://your-jenkins-url -auth username:password safe-restart
