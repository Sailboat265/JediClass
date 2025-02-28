class X2Effect_ForceMeditate extends X2Effect_Stunned;

var bool bStunLevelMatchesRemainingAP;
var float RegenAmount;
var name EventToTriggerOnRegen;
var localized string RegenMessage;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit OldTargetState, NewTargetState;
	local UnitValue CurrentForce, MaxForce;
	local int AmountToRegen;

	DamageTypes.Length = 0;

	OldTargetState = XComGameState_Unit(kNewTargetState);
	OldTargetState.GetUnitValue(class'X2Effect_JediForcePool_ByRank'.default.CurrentForceName, CurrentForce);
	OldTargetState.GetUnitValue(class'X2Effect_JediForcePool_ByRank'.default.MaxForceName, MaxForce);

	AmountToRegen = MaxForce.fValue - CurrentForce.fValue;

	if (AmountToRegen > Round(RegenAmount * MaxForce.fValue))
		AmountToRegen = Round(RegenAmount * MaxForce.fValue);

	NewTargetState = XComGameState_Unit(NewGameState.ModifyStateObject(OldTargetState.Class, OldTargetState.ObjectID));
	NewTargetState.SetUnitFloatValue(class'X2Effect_JediForcePool_ByRank'.default.CurrentForceName, CurrentForce.fValue + AmountToRegen, eCleanup_BeginTactical);

	if (bStunLevelMatchesRemainingAP)
	{
		StunLevel = OldTargetState.ActionPoints.Length;
	}
	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}

simulated function AddX2ActionsForVisualization_Removed(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult, XComGameState_Effect RemovedEffect)
{
	local XComGameStateContext Context;

	Context = VisualizeGameState.GetContext();
	Context.SetAssociatedPlayTiming(SPT_BeforeParallel);

	super.AddX2ActionsForVisualization_Removed(VisualizeGameState, ActionMetadata, EffectApplyResult, RemovedEffect);
}

defaultproperties
{
	DamageTypes.Empty
	EffectName="ForceMeditation"
	bIsImpairing=true
	CustomIdleOverrideAnim="NO_ForceMeditationLoopA"
	StunStartAnimName="NO_ForceMeditationStartA"
	StunStopAnimName="NO_ForceMeditationStopA"
}