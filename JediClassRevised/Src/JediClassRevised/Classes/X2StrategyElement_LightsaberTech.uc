class X2StrategyElement_LightsaberTech extends X2StrategyElement config(JediClass);

var config array<name> LIGHTSABER_PROJECT_NAMES;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Weapons;

	// Projects
	Weapons.AddItem(CreateTemplate_LightSaber_Conventional_Project());
	Weapons.AddItem(CreateTemplate_LightSaber_Magnetic_Project());
	Weapons.AddItem(CreateTemplate_LightSaber_Beam_Project());

	Weapons.AddItem(CreateTemplate_Saberstaff_Conventional_Project());
	Weapons.AddItem(CreateTemplate_Saberstaff_Magnetic_Project());
	Weapons.AddItem(CreateTemplate_Saberstaff_Beam_Project());
	
	return Weapons;
}

static function X2DataTemplate CreateTemplate_LightSaber_Conventional_Project()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;
	local ArtifactCost Artifacts;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, default.LIGHTSABER_PROJECT_NAMES[0]);

	Template.strImage = "img:///LightSaber_CV.UI.LightsaberIcon";
	Template.PointsToComplete = class'X2StrategyElement_DefaultTechs'.static.StafferXDays(1, 9);
	Template.bProvingGround = true;
	Template.bRepeatable = true;
	Template.SortingTier = 4;
	Template.ItemRewards.AddItem(class'X2Item_LightSaber'.default.LIGHTSABER_TEMPLATE_NAMES[0]);
	Template.ItemRewards.AddItem(name(class'X2Item_LightSaber'.default.LIGHTSABER_TEMPLATE_NAMES[0] $ "_Primary"));
	Template.ResearchCompletedFn = GiveAllItemRewards;

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('ModularWeapons');

	// Cost
	Artifacts.ItemTemplateName = 'EleriumCore';
	Artifacts.Quantity = 0;
	Template.Cost.ArtifactCosts.AddItem(Artifacts);

	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 25;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'AlienAlloy';
	Resources.Quantity = 5;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumDust';
	Resources.Quantity = 2;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

static function X2DataTemplate CreateTemplate_LightSaber_Magnetic_Project()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;
	local ArtifactCost Artifacts;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, default.LIGHTSABER_PROJECT_NAMES[1]);

	Template.strImage = "img:///LightSaber_CV.UI.LightsaberIcon";
	Template.PointsToComplete = class'X2StrategyElement_DefaultTechs'.static.StafferXDays(1, 12);
	Template.bProvingGround = true;
	Template.bRepeatable = true;
	Template.SortingTier = 4;
	Template.ItemRewards.AddItem(class'X2Item_LightSaber'.default.LIGHTSABER_TEMPLATE_NAMES[1]);
	Template.ItemRewards.AddItem(name(class'X2Item_LightSaber'.default.LIGHTSABER_TEMPLATE_NAMES[1] $ "_Primary"));
	Template.ResearchCompletedFn = GiveAllItemRewards;

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventStunLancer');

	// Cost
	Artifacts.ItemTemplateName = 'CorpseAdventStunLancer';
	Artifacts.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Artifacts);

	Artifacts.ItemTemplateName = 'EleriumCore';
	Artifacts.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Artifacts);

	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 50;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'AlienAlloy';
	Resources.Quantity = 10;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumDust';
	Resources.Quantity = 5;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

static function X2DataTemplate CreateTemplate_LightSaber_Beam_Project()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;
	local ArtifactCost Artifacts;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, default.LIGHTSABER_PROJECT_NAMES[2]);

	Template.strImage = "img:///LightSaber_CV.UI.LightsaberIcon";
	Template.PointsToComplete = class'X2StrategyElement_DefaultTechs'.static.StafferXDays(1, 15);
	Template.bProvingGround = true;
	Template.bRepeatable = true;
	Template.SortingTier = 4;
	Template.ItemRewards.AddItem(class'X2Item_LightSaber'.default.LIGHTSABER_TEMPLATE_NAMES[2]);
	Template.ItemRewards.AddItem(name(class'X2Item_LightSaber'.default.LIGHTSABER_TEMPLATE_NAMES[2] $ "_Primary"));
	Template.ResearchCompletedFn = GiveAllItemRewards;

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('AutopsyArchon');

	// Cost
	Artifacts.ItemTemplateName = 'CorpseArchon';
	Artifacts.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Artifacts);

	Artifacts.ItemTemplateName = 'EleriumCore';
	Artifacts.Quantity = 2;
	Template.Cost.ArtifactCosts.AddItem(Artifacts);

	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 75;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'AlienAlloy';
	Resources.Quantity = 25;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumDust';
	Resources.Quantity = 10;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

static function X2DataTemplate CreateTemplate_Saberstaff_Conventional_Project()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;
	local ArtifactCost Artifacts;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, default.LIGHTSABER_PROJECT_NAMES[3]);

	Template.strImage = "img:///LightSaber_CV.UI.LightsaberIcon";
	Template.PointsToComplete = class'X2StrategyElement_DefaultTechs'.static.StafferXDays(1, 9);
	Template.bProvingGround = true;
	Template.bRepeatable = true;
	Template.SortingTier = 4;
	Template.ItemRewards.AddItem(class'X2Item_LightSaber'.default.LIGHTSABER_TEMPLATE_NAMES[3]);
	Template.ResearchCompletedFn = GiveAllItemRewards;

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('ModularWeapons');

	// Cost
	Artifacts.ItemTemplateName = 'EleriumCore';
	Artifacts.Quantity = 0;
	Template.Cost.ArtifactCosts.AddItem(Artifacts);

	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 25;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'AlienAlloy';
	Resources.Quantity = 5;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumDust';
	Resources.Quantity = 2;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

static function X2DataTemplate CreateTemplate_Saberstaff_Magnetic_Project()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;
	local ArtifactCost Artifacts;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, default.LIGHTSABER_PROJECT_NAMES[4]);

	Template.strImage = "img:///LightSaber_CV.UI.LightsaberIcon";
	Template.PointsToComplete = class'X2StrategyElement_DefaultTechs'.static.StafferXDays(1, 12);
	Template.bProvingGround = true;
	Template.bRepeatable = true;
	Template.SortingTier = 4;
	Template.ItemRewards.AddItem(class'X2Item_LightSaber'.default.LIGHTSABER_TEMPLATE_NAMES[4]);
	Template.ResearchCompletedFn = GiveAllItemRewards;

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventStunLancer');

	// Cost
	Artifacts.ItemTemplateName = 'CorpseAdventStunLancer';
	Artifacts.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Artifacts);

	Artifacts.ItemTemplateName = 'EleriumCore';
	Artifacts.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Artifacts);

	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 50;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'AlienAlloy';
	Resources.Quantity = 10;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumDust';
	Resources.Quantity = 5;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

static function X2DataTemplate CreateTemplate_Saberstaff_Beam_Project()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;
	local ArtifactCost Artifacts;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, default.LIGHTSABER_PROJECT_NAMES[5]);

	Template.strImage = "img:///LightSaber_CV.UI.LightsaberIcon";
	Template.PointsToComplete = class'X2StrategyElement_DefaultTechs'.static.StafferXDays(1, 15);
	Template.bProvingGround = true;
	Template.bRepeatable = true;
	Template.SortingTier = 4;
	Template.ItemRewards.AddItem(class'X2Item_LightSaber'.default.LIGHTSABER_TEMPLATE_NAMES[5]);
	Template.ResearchCompletedFn = GiveAllItemRewards;

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('AutopsyArchon');

	// Cost
	Artifacts.ItemTemplateName = 'CorpseArchon';
	Artifacts.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Artifacts);

	Artifacts.ItemTemplateName = 'EleriumCore';
	Artifacts.Quantity = 2;
	Template.Cost.ArtifactCosts.AddItem(Artifacts);

	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 75;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'AlienAlloy';
	Resources.Quantity = 25;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumDust';
	Resources.Quantity = 10;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

static function GiveAllItemRewards(XComGameState NewGameState, XComGameState_Tech TechState)
{
	local X2ItemTemplateManager ItemTemplateManager;
	local X2ItemTemplate ItemTemplate;
	local array<name> ItemRewards;
	local name ItemReward;
	
	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	
	ItemRewards = TechState.GetMyTemplate().ItemRewards;

	foreach ItemRewards(ItemReward)
	{
		ItemTemplate = ItemTemplateManager.FindItemTemplate(ItemReward);
		class'XComGameState_HeadquartersXCom'.static.GiveItem(NewGameState, ItemTemplate);
	}

	TechState.ItemRewards.Length = 0; // Reset the item rewards array in case the tech is repeatable
	TechState.ItemRewards.AddItem(ItemTemplate); // Needed for UI Alert display info
	TechState.bSeenResearchCompleteScreen = false; // Reset the research report for techs that are repeatable
}