local FileIdent = "SpawnCivilianElement"

Hooks:PreHook(ElementSpawnCivilian, "on_executed", "CrimDusk_DisableSafehouseCharacters", function(self)
  if managers.job:current_level_id() ~= "chill" then Hooks:RemovePreHook("CrimDusk_DisableSafehouseCharacters") return end
  local EnabledState = self._values.enabled

  if self._editor_name == "hoxton" and (Global.CrimDusk.data["heists_won" .. CrimDusk.IsPermadeath()] > 4 and Global.CrimDusk.data.free_hoxton < 4) then
    CrimDusk.Log(FileIdent, "Disabling Hoxton", true)
    self._values.enabled = false

  elseif self._editor_name == "rust" and not Global.CrimDusk.data["rust_recruited" .. CrimDusk.IsPermadeath()] then
    CrimDusk.Log(FileIdent, "Disabling Rust", true)
    self._values.enabled = false
  end
end)