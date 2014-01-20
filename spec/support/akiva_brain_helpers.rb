module AkivaBrainHelpers

  def reload_core_brain
    Akiva.send(:remove_const, :Brain)
    load File.join(File.dirname(__FILE__), "../../lib/akiva/brain.rb")
    
    ["helpers", "filters", "actions", "formatters"].each do |folder|
      Dir[File.join(File.dirname(__FILE__), "../../lib/akiva/core_brain/", folder, "**/*.rb")].each {|file| load file }
    end

  end

end