if NetworkHelper:IsClient() then return end

Hooks:PostHook(BaseNetworkSession, "on_peer_sync_complete", "CrimDusk_PeerSync", function(self, _, peer_id)
  if managers.job:current_job_id() == "vit" then NetworkHelper:SendToPeer(peer_id, "CrimDusk_WhiteHousePayout", tweak_data.narrative.jobs.vit.payout[1]) end
  --if Global.CrimDusk.data.heists_won < 5 and not CrimDusk.SettingsData.permadeath then NetworkHelper:SendToPeer(peer_id, "CrimDusk_Prologue", true) end
end)