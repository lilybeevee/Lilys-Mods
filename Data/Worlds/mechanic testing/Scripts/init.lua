local mod = {}

function mod.load()
  mod.reload()
end

function mod.unload()
  mod.reload()
end

function mod.reload()
  loadscript("Data/values")
  loadscript("Data/blocks")
  loadscript("Data/changes")
  loadscript("Data/colours")
  loadscript("Data/conditions")
  loadscript("Data/constants")
  loadscript("Data/convert")
  loadscript("Data/debug")
  loadscript("Data/dynamictiling")
  loadscript("Data/effects")
  loadscript("Data/ending")
  loadscript("Data/features")
  loadscript("Data/map")
  loadscript("Data/menu")
  loadscript("Data/metadata")
  loadscript("Data/movement")
  loadscript("Data/rules")
  loadscript("Data/syntax")
  loadscript("Data/tools")
  loadscript("Data/undo")
  loadscript("Data/update")
  loadscript("Data/utf_decoder")
end

return mod
