do
    ---@type table<string, unit | table<string, unit>>
    units = {}

    ---@type table<string, player | table <string, player>>
    players = {}

    quests = {
        ---@class QuestDefinition
        ---@field data quest | nil
        ---@field required boolean
        ---@field discovered boolean
        ---@field title string
        ---@field iconPath string
        ---@field description string
        ---@field message string
        ---@field items table<integer, string>
        main = {
            data = nil,
            required = true,
            discovered = false,
            title = "Purity",
            iconPath = "ReplaceableTextures\\CommandButtons\\BTNHeroDreadLord.blp",
            description = "The Scourge has brought its blight to Ashenvale under the leadership of the dreadlord Terrordar. Priestess Mira Whitemane leads the night elves on an offensive to drive away the demon's undead army.",
            message = "|cffffcc00MAIN QUEST|r\nPurity - Destroy Terrordar's green Undead base",
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
            message = "|cffffcc00OPTIONAL QUEST|r\nNature's Guardians - Rescue all Ashenvale Guardians",
            items = {
                "Rescue all Ashenvale Guardians"
            }
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
            --priestess = gg_unit_E002_0224,
            --dreadlord = gg_unit_Udre_0080,
            --lich = gg_unit_Ulic_0067,
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

    OnInit.global(InitPlayers)
    OnInit.map(InitUnits)
end