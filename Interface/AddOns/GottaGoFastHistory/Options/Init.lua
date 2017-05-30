function GottaGoFastHistory:InitOptions()
  local defaults = {
    profile = {
      History = {},
    },
  }
  GottaGoFastHistory.db = LibStub("AceDB-3.0"):New("GottaGoFastHistoryDB", defaults, true);
end
