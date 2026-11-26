Hooks:OverrideFunction(SkirmishTweakData, "_init_ransom_amounts", function(self)
  self.ransom_amounts = {
    100000,   -- Wave 1 [Normal]
    250000,   -- Wave 2 [Hard]
    500000,   -- Wave 3 [Very Hard]
    750000,   -- Wave 4 [Very Hard]
    1250000,  -- Wave 5 [OVERKILL]
    2000000,  -- Wave 6 [OVERKILL]
    5000000,  -- Wave 7 [Mayhem]
    10000000, -- Wave 8 [Mayhem]
    25000000  -- Wave 9 [Death Wish]
  }
end)