do
    ---@type table<string, unit | table<string, unit>>
    units = {}

    ---@type table<string, player | table <string, player>>
    players = {}

    ---@type table<string, string>
    cmd_str = {
        autoharvestgold = "autoharvestgold",
        autoharvestlumber = "autoharvestlumber",
        entangleinstant = "entangleinstant",
    }

    ---@type table<string, QuestDefinition>
    quests = {
        ---@class QuestDefinition
        ---@field data quest | nil
        ---@field required boolean
        ---@field discovered boolean
        ---@field title string
        ---@field iconPath string
        ---@field description string
        ---@field items table<number, string>
        main = {
            data = nil,
            required = true,
            discovered = false,
            title = "Purity",
            iconPath = "ReplaceableTextures\\CommandButtons\\BTNHeroDreadLord.blp",
            description = "The Scourge has brought its blight to Ashenvale " ..
                            "under the leadership of the dreadlord Terrordar. " ..
                            "Priestess Mira Whitemane leads the night elves on an offensive to " ..
                            "drive away the demon's undead army. ",
            items = {
                "Destroy Terrordar's green Undead base"
            }
        },
        rescue = {
            data = nil,
            required = false,
            discovered = false,
            title = "Nature's Guardians",
            iconPath = "ReplaceableTextures\\CommandButtons\\BTNDryad.blp",
            description = "The Scourge's blight has stirred the creatures of the forest from their dens and burrows. The druids and dryads of Ashenvale will join your quest if you help them.",
            items = {
                "Rescue all Ashenvale Guardians"
            }
        },
        orange = {
            data = nil,
            required = false,
            discovered = false,
            title = "Comorbidity",
            iconPath = "ReplaceableTextures\\CommandButtons\\BTNLichVersion2.blp",
            description = "The lich Rage Winterchill leads an ancillary force of undead encroaching upon the forest west of the river. While they represent a smaller threat, destroying their outpost may yield access to additional resources.",
            items = {
                "Destroy Rage Winterchill's orange Undead base"
            }
        }
    }

    ---@type table<string, string>
    items = {
        mantle = "rin1",
        claws3 = "rat3",
        claws8 = "rat9",
        pring1 = "rde0",
        pring2 = "rde1",
        print3 = "rde2",
        penrg = "penr"
    }

    spells = {
        ud = {
            aura_vamp = "AUav",
            carrion_swarm = "AUcs",
            dark_ritual = "AUdr",
            death_decay = "AUdd",
            frost_armor = "AUfu",
            frost_nova = "AUfn",
            inferno = "AUin",
            sleep = "AUsl",
        }
    }


    local function InitPlayers()
        players = {
            player = Player(1),
            allies = Player(2),
            orange = Player(5),
            green = Player(6),
            neutral_hostile = Player(PLAYER_NEUTRAL_AGGRESSIVE),
            neutral_passive = Player(PLAYER_NEUTRAL_PASSIVE),
        }
    end


    local function InitUnits()
        units = {
            tree = gg_unit_etol_0003,
            priestess = gg_unit_E002_0224,
            dreadlord = gg_unit_Udre_0080,
            lich = gg_unit_Ulic_0067,
            mines = {
                player = gg_unit_ngol_0004
            },
            workers = {
                gold = {
                    gg_unit_ewsp_0007,
                    gg_unit_ewsp_0008,
                    gg_unit_ewsp_0009,
                    gg_unit_ewsp_0010,
                    gg_unit_ewsp_0011,
                },
                lumber = {
                    gg_unit_ewsp_0012,
                    gg_unit_ewsp_0013,
                    gg_unit_ewsp_0014,
                }
            }
        }
    end

    OnInit.final(InitPlayers)
    OnInit.final(InitUnits)
    OnInit.final(function()
        for _, def in pairs(quests) do
            def.data = InitQuest(def)
        end
    end)
end