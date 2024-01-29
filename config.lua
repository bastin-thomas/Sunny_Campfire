Config = {}
----------------------------------------------------------
Config.Debug = false
----------------------------------------------------------
Config.campfireProp = "p_campfire_under01x"
Config.campfirePropburnout = "p_campfireburntout02x"
Config.PermanentFireProp = "p_campfirewhitefish03x"
Config.feu = {
    Straw = {
        Pos = {x = -1351.96, y = 2440.02, z = 308.43}, -- location 
    },
}
----------------------------------------------------------
Config.fireStarterItem = "campfire" -- make sure to add this item to the database
Config.firewood = "wood"
Config.startFireAmount = 3
----------------------------------------------------------
Config.fireBaseTime = 360
Config.fireRestartBaseTime = 180
Config.EmberTimer = 1200
Config.woodAddTime = 120
----------------------------------------------------------
Config.miniGameDifficulty = 2000
----------------------------------------------------------
Config.Canteen = {
    [1] = "canteen",      --First one is the fullfilled one
    [2] = "canteen_75",
    [3] = "canteen_50",
    [4] = "canteen_25",
    [5] = "canteenempty", --Lastone is the empty one
}

----------------------------------------------------------
Config.Craft = {
    [01] = {
        --- T1: Food
        MenuName = "Recette Basique";
        Craft = {
            [01] = {
                CraftName = "Brochette de Volaille",
                UnlockItem = "null",
                CraftingTime = 5,  -- in seconds
                itemUtil = {
                    { id = "meat_b", qty = 2, tool = false, weapon = false },
                },
                itemGain = {
                    { id = "b_blanche_cuite", qtyGain = 1, IsProp = false, weapon = false },
                }
            },
            [02] = {
                CraftName = "Brochette de Gibier",
                UnlockItem = "null",
                CraftingTime = 5,  -- in seconds
                itemUtil = {
                    { id = "meat_n",      qty = 2,    tool = false, weapon = false },
                },
                itemGain = {
                    { id = "b_gibier_cuite",    qtyGain = 1, IsProp = false, weapon = false },
                }
            },
            [03] = {
                CraftName = "Brochette de Poisson", --Name of the Craft
                UnlockItem = "null",      -- If need a setjob
                CraftingTime = 5,  -- in seconds
                itemUtil = {
                    { id = "fish",       qty = 2,    tool = false, weapon = false }
                },
                itemGain = {
                    { id = "b_poisson_cuite", qtyGain = 1, IsProp = false, weapon = false },
                }
            }
        }
    },


    [02] = {
        --- T2: Food
        MenuName = "Recette Simple";
        Craft = {
            [01] = {
                CraftName = "Brochette de Volaille à l'Origan", --Name of the Craft
                UnlockItem = "null", -- If need a setjob
                CraftingTime = 10, -- in seconds
                itemUtil = {
                    { id = "meat_b",    qty = 2,    tool = false, weapon = false },

                    { id = "oregano",   qty = 1,    tool = false, weapon = false },
                },
                itemGain = {
                    { id = "b_blanche_origan_cuite",  qtyGain = 1, IsProp = false, weapon = false },
                }
            },
            [02] = {
                CraftName = "Brochette de Gibier au Thym", --Name of the Craft
                UnlockItem = "null",      -- If need a setjob
                CraftingTime = 10,  -- in seconds
                itemUtil = {
                    { id = "meat_n",            qty = 2,    tool = false, weapon = false },

                    { id = "Creeking_Thyme",    qty = 1,    tool = false, weapon = false },
                },
                itemGain = {
                    { id = "b_gibier_thym_cuite",   qtyGain = 1, IsProp = false, weapon = false },
                }
            },
            [03] = {
                CraftName = "Omelette avec Viande de Gibier", --Name of the Craft
                UnlockItem = "null",      -- If need a setjob
                CraftingTime = 10,  -- in seconds
                itemUtil = {
                    { id = "oeuf",          qty = 2,    tool = false, weapon = false },

                    { id = "meat_n",        qty = 2,    tool = false, weapon = false },
                },
                itemGain = {
                    { id = "c_omelette",    qtyGain = 1, IsProp = false, weapon = false },
                }
            },
            [04] = {
                CraftName = "Omelette avec Volaille", --Name of the Craft
                UnlockItem = "null",      -- If need a setjob
                CraftingTime = 10,  -- in seconds
                itemUtil = {
                    { id = "oeuf",          qty = 2,    tool = false, weapon = false },

                    { id = "meat_b",        qty = 2,    tool = false, weapon = false },
                },
                itemGain = {
                    { id = "c_omelette",    qtyGain = 1, IsProp = false, weapon = false },
                }
            },
            [05] = {
                CraftName = "Soupe de Champignons", --Name of the Craft
                UnlockItem = "null",      -- If need a setjob
                CraftingTime = 15,  -- in seconds
                itemUtil = {
                    { id = "Bay_Bolete",    qty = 2,    tool = false, weapon = false },
                    { id = "Chanterelles",  qty = 2,    tool = false, weapon = false },
                    { id = "canteen",       qty = 1,    tool = false, weapon = false },
                },
                itemGain = {
                    { id = "soupe_mushroom",    qtyGain = 1, IsProp = false, weapon = false },
                    { id = "canteen",           qtyGain = 1, IsProp = false, weapon = false },
                }
            },
        }
    },


    [03] = {
        -- T3: Food
        MenuName = "Recette intermédiaire";
        Craft = {
            [01] = {
                CraftName = "Tarte au Pomme", --Name of the Craft
                UnlockItem = "null",      -- If need a setjob
                CraftingTime = 10,  -- in seconds
                itemUtil = {
                    { id = "oeuf",      qty = 2,    tool = false, weapon = false },
                    { id = "farine_c",  qty = 1,    tool = false, weapon = false },
                    { id = "pomme_c",   qty = 3,    tool = false, weapon = false },

                    { id = "cuillere_bois", qty = 1,tool = true,  weapon = false },
                },
                itemGain = {
                    { id = "tarte_c",  qtyGain = 5, IsProp = false, weapon = false },
                }
            },
            [02] = {
                CraftName = "Ragoût de Gibier", --Name of the Craft
                UnlockItem = "null",      -- If need a setjob
                CraftingTime = 20,  -- in seconds
                itemUtil = {
                    { id = "meat_n",            qty = 3,    tool = false, weapon = false },
                    
                    { id = "patate",            qty = 1,    tool = false, weapon = false },
                    { id = "Wild_Carrot",       qty = 2,    tool = false, weapon = false },
                    { id = "Crows_Garlic",      qty = 1,    tool = false, weapon = false },

                    { id = "cuillere_bois",     qty = 1,    tool = true , weapon = false },
                },
                itemGain = {
                    { id = "consumable_ragoud", qtyGain = 1, IsProp = false, weapon = false },
                }
            },
            [03] = {
                CraftName = "Ragoût de Volaille", --Name of the Craft
                UnlockItem = "null",      -- If need a setjob
                CraftingTime = 20,  -- in seconds
                itemUtil = {
                    { id = "meat_b",            qty = 3,    tool = false, weapon = false },

                    { id = "patate",            qty = 1,    tool = false, weapon = false },
                    { id = "Wild_Carrot",       qty = 2,    tool = false, weapon = false },
                    { id = "Crows_Garlic",      qty = 1,    tool = false, weapon = false },

                    { id = "cuillere_bois",     qty = 1,    tool = true , weapon = false },
                },
                itemGain = {
                    { id = "consumable_ragoud", qtyGain = 1, IsProp = false, weapon = false },
                }
            },
            [04] = {
                CraftName = "Ragoût de Poisson", --Name of the Craft
                UnlockItem = "null",      -- If need a setjob
                CraftingTime = 20,  -- in seconds
                itemUtil = {
                    { id = "fish",              qty = 2,     tool = false, weapon = false },

                    { id = "patate",            qty = 1,     tool = false, weapon = false },
                    { id = "Wild_Carrot",       qty = 2,     tool = false, weapon = false },
                    { id = "Crows_Garlic",      qty = 1,     tool = false, weapon = false },

                    { id = "cuillere_bois",     qty = 1,     tool = true , weapon = false },
                },
                itemGain = {
                    { id = "consumable_ragoud_fish", qtyGain = 1, IsProp = false, weapon = false },
                }
            },
            [05] = {
                CraftName = "Soupe de Légumes", --Name of the Craft
                UnlockItem = "null",      -- If need a setjob
                CraftingTime = 20,  -- in seconds
                itemUtil = {
                    { id = "Crows_Garlic",      qty = 1,    tool = false, weapon = false },
                    { id = "patate",            qty = 3,    tool = false, weapon = false },
                    { id = "Wild_Carrot",       qty = 3,    tool = false, weapon = false },
                    { id = "canteen",           qty = 1,    tool = false, weapon = false },
        
                    { id = "cuillere_bois",     qty = 1,    tool = true , weapon = false },
                },
                itemGain = {
                    { id = "soupe_c",           qtyGain = 2, IsProp = false, weapon = false },
                    { id = "canteen",           qtyGain = 1, IsProp = false, weapon = false },
                }
            },
        }
    },
    

    

    [04] = {
        -- T4: Food
        MenuName = "Recette Complexe";
        Craft = {
            [01] = {
                CraftName = "Steak Sauce Champignon", --Name of the Craft
                UnlockItem = "null",      -- If need a setjob
                CraftingTime = 30,  -- in seconds
                itemUtil = {
                    { id = "meat_n",         qty = 4,    tool = false, weapon = false },

                    { id = "Bay_Bolete",     qty = 1,    tool = false, weapon = false },
                    { id = "Chanterelles",   qty = 2,    tool = false, weapon = false },
                    { id = "patate",         qty = 2,    tool = false, weapon = false },

                    { id = "Crows_Garlic",   qty = 1,    tool = false, weapon = false },
                    { id = "Creeking_Thyme", qty = 1,    tool = false, weapon = false },
                },
                itemGain = {
                    { id = "steak_champi",   qtyGain = 1, IsProp = false, weapon = false },
                }
            },
            [02] = {
                CraftName = "Poulet au Légume", --Name of the Craft
                UnlockItem = "null",      -- If need a setjob
                CraftingTime = 30,  -- in seconds
                itemUtil = {
                    { id = "meat_b",         qty = 4,    tool = false, weapon = false },

                    { id = "Wild_Carrot",    qty = 2,    tool = false, weapon = false },
                    { id = "patate",         qty = 2,    tool = false, weapon = false },

                    { id = "Crows_Garlic",   qty = 1,    tool = false, weapon = false },
                    { id = "oregano",        qty = 1,    tool = false, weapon = false },
                },
                itemGain = {
                    { id = "poulet_legume",   qtyGain = 1, IsProp = false, weapon = false },
                }
            },
        }
    },



    [05] = {
        -- Infusion
        MenuName = "Infusion";
        Craft = {
            [1] = {
                CraftName = "Infusion de Sauge", --Name of the Craft
                UnlockItem = "null",      -- If need a setjob
                CraftingTime = 10,  -- in seconds
                itemUtil = {
                    { id = "sauge",     qty = 2,    tool = false, weapon = false },
                    { id = "canteen",   qty = 1,    tool = false, weapon = false },
                },
                itemGain = {
                    { id = "infusion_sauge",    qtyGain = 1, IsProp = false, weapon = false },
                    { id = "canteen",           qtyGain = 1, IsProp = false, weapon = false },
                }
            },
            [2] = {
                CraftName = "Infusion de Camomille", --Name of the Craft
                UnlockItem = "null",      -- If need a setjob
                CraftingTime = 10,  -- in seconds
                itemUtil = {
                    { id = "Wild_Feverfew",     qty = 2,    tool = false, weapon = false },
                    { id = "canteen",           qty = 1,    tool = false, weapon = false },
                },
                itemGain = {
                    { id = "infusion_camomille",    qtyGain = 1, IsProp = false, weapon = false },
                    { id = "canteen",               qtyGain = 1, IsProp = false, weapon = false },
                }
            },
            [3] = {
                CraftName = "Concoction anti-stress",
                UnlockItem = "medic",
                CraftingTime = 20,  -- in seconds
                itemUtil = {
                    { id = "pavot_c",   qty = 1,    tool = false, weapon = false },
                    { id = "ginseng",   qty = 1,    tool = false, weapon = false },
                    { id = "sauge",     qty = 1,    tool = false, weapon = false },
                    { id = "canteen",   qty = 1,    tool = false, weapon = false },
                },
                itemGain = {
                    { id = "potion_anti_stress",    qtyGain = 1, IsProp = false, weapon = false },
                    { id = "canteen",               qtyGain = 1, IsProp = false, weapon = false },
                }
            },
            [4] = {
                CraftName = "Tonic",
                UnlockItem = "medic",
                CraftingTime = 20,  -- in seconds
                itemUtil = {
                    { id = "sauge",     qty = 2,    tool = false, weapon = false },
                    { id = "ginseng",   qty = 2,    tool = false, weapon = false },
                    { id = "canteen",   qty = 1,    tool = false, weapon = false },
                },
                itemGain = {
                    { id = "tonic",     qtyGain = 1, IsProp = false, weapon = false },
                    { id = "canteen",   qtyGain = 1, IsProp = false, weapon = false },
                }
            },
            [5] = {
                CraftName = "Stimulant pour chevaux",
                UnlockItem = "null",
                CraftingTime = 20,  -- in seconds
                itemUtil = {
                    { id = "pavot_c",       qty = 2,    tool = false, weapon = false },
                    { id = "jonc_commun",   qty = 2,    tool = false, weapon = false },
                    { id = "canteen",       qty = 1,    tool = false, weapon = false },
                },
                itemGain = {
                    { id = "stim",      qtyGain = 1, IsProp = false, weapon = false },
                    { id = "canteen",   qtyGain = 1, IsProp = false, weapon = false },
                }
            },
        }
    },
}