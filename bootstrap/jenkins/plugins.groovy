def plugins = jenkins.model.Jenkins.instance.getPluginManager().getPlugins()
def pluginSet = [] as HashSet

plugins.each {
    def plugin = it.getShortName()
    def version = it.getVersion()
  pluginSet.add("     '${plugin}':\n " + '         version: \'' + version + '\'' )
 
  
  /*
#      git:
#         version: '1.1.1'

*/
  
  /*
  def deps =  it.getDependencies()
    deps.each {
      def s = it.shortName
      def version2 = it.getVersion()
      pluginSet.add("     '${s}': " + '{' + version2 + '}')
    }
*/
  
} 

pluginSet.each {println it}


