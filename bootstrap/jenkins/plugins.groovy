def plugins = jenkins.model.Jenkins.instance.getPluginManager().getPlugins()
def pluginSet = [] as HashSet

plugins.each {
    def plugin = it.getShortName()
    def version = it.getVersion()
    pluginSet.add("     '${plugin}':\n " + '         version: \'' + version + '\'' )
} 

pluginSet.each {println it}


