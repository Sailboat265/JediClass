//-----------------------------------------------------------
//	Class:	X2Effect_TriggerAbilityReaction
//	Author: Musashi
//	Pretty much a copy from X2Effect_CoveringFire with some tweaks to support melee ability triggers
//-----------------------------------------------------------

class X2Effect_TriggerAbilityReaction extends X2Effect_Persistent;

var name AbilityToActivate;				//  ability to activate when the covering fire check is matched
var name GrantActionPoint;				//  action point to give the shooter when covering fire check is matched
var name GrantReserveActionPoint;		//  action point to give the shooter when covering fire check is matched
var int MaxActionPointsPerTurn;			//  max times per turn the action point can be granted
var bool bDirectAttackOnly;				//  covering fire check can only match when the target of this effect is directly attacked
var bool bPreEmptiveFire;				//  if true, the reaction fire will happen prior to the attacker's shot; otherwise it will happen after
var bool bOnlyDuringEnemyTurn;			//  only activate the ability during the enemy turn (e.g. prevent return fire during the sharpshooter's own turn)
var bool bUseMultiTargets;				//  initiate AbilityToActivate against yourself and look for multi targets to hit, instead of direct retaliation
var bool bOnlyWhenAttackMisses;			//  Only activate the ability if the attack missed
var bool bSelfTargeting;				//  The ability being activated targets the covering unit (self)
var int	ActivationPercentChance;		//  If this is greater than zero, this is the percent chance the AbilityToActivate is activated

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local Object EffectObj;

	EventMgr = `XEVENTMGR;

	EffectObj = EffectGameState;

	EventMgr.RegisterForEvent(
		EffectObj,
		'AbilityActivated',
		class'X2Effect_TriggerAbilityReaction'.static.OnAbilityActivated,
		ELD_OnStateSubmitted, , , ,
		EffectObj
	);
}

static function EventListenerReturn OnAbilityActivated(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameState_Unit AttackingUnit, CoveringUnit;
	local XComGameStateHistory History;
	local X2Effect_TriggerAbilityReaction TriggerAbilityReactionEffect;
	local StateObjectReference AbilityRef;
	local XComGameState_Ability AbilityState;
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState NewGameState;
	local XComGameState_Effect EffectGameState;
	local XComGameState_Effect NewEffectState;
	local X2AbilityTemplate AbilityTemplate;
	local X2TargetingMethod TargetingMethod;
	local XComGameState_Item ItemState;
	local int RandRoll;

	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	EffectGameState = XComGameState_Effect(CallbackData);
	
	if (AbilityContext != none && EffectGameState != none)
	{
		History = `XCOMHISTORY;
		
		CoveringUnit = XComGameState_Unit(History.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
		AttackingUnit = class'X2TacticalGameRulesetDataStructures'.static.GetAttackingUnitState(GameState);
		if (AttackingUnit != none && AttackingUnit.IsEnemyUnit(CoveringUnit))
		{
			TriggerAbilityReactionEffect = X2Effect_TriggerAbilityReaction(EffectGameState.GetX2Effect());
			`assert(TriggerAbilityReactionEffect != none);
			
			if (TriggerAbilityReactionEffect.bOnlyDuringEnemyTurn)
			{
				//  make sure it's the enemy turn if required
				if (`TACTICALRULES.GetCachedUnitActionPlayerRef().ObjectID != AttackingUnit.ControllingPlayer.ObjectID)
					return ELR_NoInterrupt;
			}

			if (TriggerAbilityReactionEffect.bPreEmptiveFire)
			{
				//  for pre emptive fire, only process during the interrupt step
				if (AbilityContext.InterruptionStatus != eInterruptionStatus_Interrupt)
					return ELR_NoInterrupt;
			}
			else
			{
				//  for non-pre emptive fire, don't process during the interrupt step
				if (AbilityContext.InterruptionStatus == eInterruptionStatus_Interrupt)
					return ELR_NoInterrupt;
			}

			if (TriggerAbilityReactionEffect.bDirectAttackOnly)
			{
				//  do nothing if the covering unit was not fired upon directly
				if (AbilityContext.InputContext.PrimaryTarget.ObjectID != CoveringUnit.ObjectID)
					return ELR_NoInterrupt;
			}

			if (TriggerAbilityReactionEffect.ActivationPercentChance > 0)
			{
				RandRoll = `SYNC_RAND_STATIC(100);
				if (RandRoll >= TriggerAbilityReactionEffect.ActivationPercentChance)
				{
					return ELR_NoInterrupt;
				}
			}

			if (TriggerAbilityReactionEffect.bOnlyWhenAttackMisses)
			{
				//  do nothing if the covering unit was not hit in the attack
				if (class'XComGameStateContext_Ability'.static.IsHitResultHit(AbilityContext.ResultContext.HitResult))
					return ELR_NoInterrupt;
			}

			AbilityRef = CoveringUnit.FindAbility(TriggerAbilityReactionEffect.AbilityToActivate);
			AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(AbilityRef.ObjectID));
			ItemState = XComGameState_Item(History.GetGameStateForObjectID(AbilityState.SourceWeapon.ObjectID));
			AbilityTemplate = AbilityState.GetMyTemplate();
			TargetingMethod = new AbilityTemplate.TargetingMethod;
			TargetingMethod.InitFromState(AbilityState);

			if (AbilityState != none)
			{
				`LOG(default.class @ GetFuncName() @
					AbilityState.GetMyTemplateName() @
					ItemState.InventorySlot
				,, 'JediClassRevised');

				if ((TriggerAbilityReactionEffect.GrantActionPoint != '' || TriggerAbilityReactionEffect.GrantReserveActionPoint != '') && 
					(TriggerAbilityReactionEffect.MaxActionPointsPerTurn > EffectGameState.GrantsThisTurn || TriggerAbilityReactionEffect.MaxActionPointsPerTurn <= 0))
				{
					NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
					NewEffectState = XComGameState_Effect(NewGameState.ModifyStateObject(EffectGameState.Class, EffectGameState.ObjectID));
					NewEffectState.GrantsThisTurn++;

					CoveringUnit = XComGameState_Unit(NewGameState.ModifyStateObject(CoveringUnit.Class, CoveringUnit.ObjectID));
					if (TriggerAbilityReactionEffect.GrantReserveActionPoint != '')
					{
						CoveringUnit.ReserveActionPoints.AddItem(TriggerAbilityReactionEffect.GrantReserveActionPoint);
					}
					if (TriggerAbilityReactionEffect.GrantActionPoint != '')
					{
						CoveringUnit.ActionPoints.AddItem(TriggerAbilityReactionEffect.GrantActionPoint);
					}

					if (AbilityState.CanActivateAbilityForObserverEvent(AttackingUnit, CoveringUnit) != 'AA_Success' &&
						AbilityState.CanActivateAbility(CoveringUnit, AbilityContext.InterruptionStatus, false) != 'AA_Success')
					{
						History.CleanupPendingGameState(NewGameState);
					}
					else
					{
						`TACTICALRULES.SubmitGameState(NewGameState);

						if (TriggerAbilityReactionEffect.bUseMultiTargets)
						{
							`LOG(default.class @ GetFuncName() @
								"AbilityTriggerAgainstSingleTarget 1" @
								TriggerAbilityReactionEffect.AbilityToActivate @
								ItemState.InventorySlot
							,, 'JediClassRevised');
							AbilityState.AbilityTriggerAgainstSingleTarget(CoveringUnit.GetReference(), true);
						}
						else
						{
							`LOG(default.class @ GetFuncName() @
								"ActivateAbilityByTemplateName 1"  @
								TriggerAbilityReactionEffect.AbilityToActivate @
								ItemState.InventorySlot
							,, 'JediClassRevised');
							class'XComGameStateContext_Ability'.static.ActivateAbilityByTemplateName(
								CoveringUnit.GetReference(),
								TriggerAbilityReactionEffect.AbilityToActivate,
								AttackingUnit.GetReference(),
								,
								TargetingMethod
							);
						}
					}
				}
				else if (TriggerAbilityReactionEffect.bSelfTargeting && AbilityState.CanActivateAbilityForObserverEvent(CoveringUnit) == 'AA_Success' &&
						AbilityState.CanActivateAbility(CoveringUnit, AbilityContext.InterruptionStatus, false) == 'AA_Success')
				{
					`LOG(default.class @ GetFuncName() @
						"AbilityTriggerAgainstSingleTarget bSelfTargeting" @
						TriggerAbilityReactionEffect.AbilityToActivate @
						ItemState.InventorySlot
					,, 'JediClassRevised');
					AbilityState.AbilityTriggerAgainstSingleTarget(CoveringUnit.GetReference(), TriggerAbilityReactionEffect.bUseMultiTargets);
				}
				else if (AbilityState.CanActivateAbilityForObserverEvent(AttackingUnit) == 'AA_Success' &&
						AbilityState.CanActivateAbility(CoveringUnit, AbilityContext.InterruptionStatus, false) == 'AA_Success')
				{
					if (TriggerAbilityReactionEffect.bUseMultiTargets)
					{
						`LOG(default.class @ GetFuncName() @
							"AbilityTriggerAgainstSingleTarget 2" @
							TriggerAbilityReactionEffect.AbilityToActivate @
							ItemState.InventorySlot
						,, 'JediClassRevised');
						AbilityState.AbilityTriggerAgainstSingleTarget(CoveringUnit.GetReference(), true);
					}
					else
					{
						`LOG(default.class @ GetFuncName() @
							"ActivateAbilityByTemplateName 2" @
							TriggerAbilityReactionEffect.AbilityToActivate @
							ItemState.InventorySlot
						,, 'JediClassRevised');
						class'XComGameStateContext_Ability'.static.ActivateAbilityByTemplateName(
							CoveringUnit.GetReference(),
							TriggerAbilityReactionEffect.AbilityToActivate,
							AttackingUnit.GetReference(),
							,
							TargetingMethod
						);
					}
				}
			}
		}
	}
	return ELR_NoInterrupt;
}

DefaultProperties
{
	bPreEmptiveFire = true
	bOnlyWhenAttackMisses = false
	bSelfTargeting = false
	ActivationPercentChance = 0
}