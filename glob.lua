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
        ---@field items table<integer, string>
        main = {
            data = nil,
            required = true,
            discovered = false,
            title = "Purity",
            iconPath = "ReplaceableTextures\\CommandButtons\\BTNHeroDreadLord.blp",
            description = "The Scourge has brought its blight to Ashenvale under the leadership of the dreadlord Terrordar. Priestess Mira Whitemane leads the night elves on an offensive to drive away the demon's undead army.",
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

    ---@param cmd string
    ---@param units table<number, unit>
    function DispatchUnits(units, cmd)
        for _, unit in ipairs(units) do
            IssueImmediateOrderBJ(unit, cmd)
        end
    end

    ---@param p player
    ---@return integer
    function CountPlayerStructures(p)
        return CountUnitsInGroup(
            GetUnitsOfPlayerMatching(p, Condition(
                IsUnitType(GetFilterUnit(), UNIT_TYPE_STRUCTURE))))
    end


    ---@param p player
    ---@param c conditionfunc
    ---@return integer
    function CountPlayerUnitsBy(p, c)
        return CountUnitsInGroup(
                GetUnitsOfPlayerMatching(p, c))
    end


    ---@param p player
    ---@param gold integer
    ---@param lumber integer
    function InitResources(p, gold, lumber)
        SetPlayerState(p, PLAYER_STATE_RESOURCE_GOLD, gold)
        SetPlayerState(p, PLAYER_STATE_RESOURCE_LUMBER, lumber)
    end


    ---@param ... player[]
    function AllyWithNeutral(...)
        for _, p in pairs({...}) do
            SetPlayerAlliance(p, players.neutral_hostile,
                ALLIANCE_PASSIVE, TRUE)
        end
    end


    ---@param u unit
    ---@param ... string
    function LearnSkills(u, ...)
        for _, skill_code in ({...}) do
            IncUnitAbilityLevel(u,
                FourCC(skill_code))
        end
    end


    ---@param u unit
    ---@param ... string
    function GiveItems(u, ...)
        for _, item_code in ({...}) do
            UnitAddItemById(u,
                FourCC(item_code))
        end
    end


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

    OnInit.global(InitPlayers)
    OnInit.final(InitUnits)
end