{-# LANGUAGE DataKinds             #-}
{-# LANGUAGE DerivingStrategies    #-}
{-# LANGUAGE FlexibleContexts      #-}
{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE GADTs                 #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings     #-}
{-# LANGUAGE ScopedTypeVariables   #-}
{-# LANGUAGE TypeApplications      #-}
{-# LANGUAGE UndecidableInstances  #-}

module Main where

import qualified Data.ByteString.Short       as Short
import qualified Data.Set                    as Set
import           PlutusTx.Blueprint
import           PlutusLedgerApi.Data.V3     (PubKeyHash)
import           PlutusLedgerApi.V3          (TokenName, TxOutRef)
import qualified Lesson03.Validators           as Lesson03
import qualified Lesson05.Vesting              as Vesting
import qualified Lesson07.Minting              as Minting

{- -------------------------------------------------------------------------------------------- -}
{- ---------------------------------------- ENTRY POINT --------------------------------------- -}

main :: IO ()
main = writeBlueprint "blueprint.json" blueprint

{- -------------------------------------------------------------------------------------------- -}
{- -------------------------------------------- SHARED ---------------------------------------- -}

blueprint :: ContractBlueprint
blueprint =
  MkContractBlueprint
    { contractId = Just "plutus-pioneer-program"
    , contractPreamble = preamble
    , contractValidators =
        Set.fromList
          [ mkGiftVal
          , mkBurnVal
          , mk42ValLarge
          , mk42ValSmall
          , mk42TypedVal
          , mk42CustomVal
          , read42ValSmall
          , vestingValidator
          , vestingValidatorParam
          , vestingValidatorMix
          , signedValidator
          , nftValidator
          , nftImgValidator
          ]
    , contractDefinitions =
        deriveDefinitions
          @[ ()
           , Integer
           , Vesting.VestingDatum
           , Vesting.VestingDatumMix
           , Vesting.VestingParam
           , PubKeyHash
           , TxOutRef
           , TokenName
           ]
    }

preamble :: Preamble
preamble =
  MkPreamble
    { preambleTitle = "Plutus Pioneer Program Blueprint"
    , preambleDescription = Just "Blueprint for the Plutus Pioneer Program validators"
    , preambleVersion = "1.0.0"
    , preamblePlutusVersion = PlutusV3
    , preambleLicense = Just "MIT"
    }

{- -------------------------------------------------------------------------------------------- -}
{- ----------------------------------- VALIDATORS - Lesson03 ---------------------------------- -}

mkGiftVal :: ValidatorBlueprint referencedTypes
mkGiftVal =
  MkValidatorBlueprint
    { validatorTitle = "Always True Validator"
    , validatorDescription = Just "Validator that always returns True (always succeeds)"
    , validatorParameters = []
    , validatorRedeemer =
        MkArgumentBlueprint
          { argumentTitle = Just "Redeemer"
          , argumentDescription = Just "Redeemer for the always true validator"
          , argumentPurpose = Set.fromList [Spend, Mint, Withdraw, Publish]
          , argumentSchema = definitionRef @()
          }
    , validatorDatum = Nothing
    , validatorCompiledCode =
        Just . Short.fromShort $ Lesson03.serializedMkGiftValidator
    }

mkBurnVal :: ValidatorBlueprint referencedTypes
mkBurnVal =
  MkValidatorBlueprint
    { validatorTitle = "Always False Validator"
    , validatorDescription = Just "Validator that always returns False (always fails)"
    , validatorParameters = []
    , validatorRedeemer =
        MkArgumentBlueprint
          { argumentTitle = Just "Redeemer"
          , argumentDescription = Just "Redeemer for the always false validator"
          , argumentPurpose = Set.fromList [Spend, Mint, Withdraw, Publish]
          , argumentSchema = definitionRef @()
          }
    , validatorDatum = Nothing
    , validatorCompiledCode =
        Just . Short.fromShort $ Lesson03.serializedMkBurnValidator
    }

mk42ValLarge :: ValidatorBlueprint referencedTypes
mk42ValLarge =
  MkValidatorBlueprint
    { validatorTitle = "42 Validator untyped - large CBOR"
    , validatorDescription = Just "Validator that returns true only if the redeemer is 42"
    , validatorParameters = []
    , validatorRedeemer =
        MkArgumentBlueprint
          { argumentTitle = Just "Redeemer"
          , argumentDescription = Just "Redeemer for the 42 validator"
          , argumentPurpose = Set.fromList [Spend, Mint, Withdraw, Publish]
          , argumentSchema = definitionRef @Integer
          }
    , validatorDatum = Nothing
    , validatorCompiledCode =
        Just . Short.fromShort $ Lesson03.serializedMk42ValidatorLarge
    }

mk42ValSmall :: ValidatorBlueprint referencedTypes
mk42ValSmall =
  MkValidatorBlueprint
    { validatorTitle = "42 Validator untyped - small CBOR"
    , validatorDescription = Just "Validator that returns true only if the redeemer is 42"
    , validatorParameters = []
    , validatorRedeemer =
        MkArgumentBlueprint
          { argumentTitle = Just "Redeemer"
          , argumentDescription = Just "Redeemer for the 42 validator"
          , argumentPurpose = Set.fromList [Spend, Mint, Withdraw, Publish]
          , argumentSchema = definitionRef @Integer
          }
    , validatorDatum = Nothing
    , validatorCompiledCode =
        Just . Short.fromShort $ Lesson03.serializedMk42ValidatorSmall
    }

mk42TypedVal :: ValidatorBlueprint referencedTypes
mk42TypedVal =
  MkValidatorBlueprint
    { validatorTitle = "42 Validator typed"
    , validatorDescription = Just "Validator that returns true only if the redeemer is 42"
    , validatorParameters = []
    , validatorRedeemer =
        MkArgumentBlueprint
          { argumentTitle = Just "Redeemer"
          , argumentDescription = Just "Redeemer for the 42 typed validator"
          , argumentPurpose = Set.fromList [Spend, Mint, Withdraw, Publish]
          , argumentSchema = definitionRef @Integer
          }
    , validatorDatum = Nothing
    , validatorCompiledCode =
        Just . Short.fromShort $ Lesson03.serializedMk42TypedValidator
    }

mk42CustomVal :: ValidatorBlueprint referencedTypes
mk42CustomVal =
  MkValidatorBlueprint
    { validatorTitle = "42 Validator custom redeemer"
    , validatorDescription = Just "Validator that returns true only if the redeemer is correctly wrapped number 42."
    , validatorParameters = []
    , validatorRedeemer =
        MkArgumentBlueprint
          { argumentTitle = Just "Redeemer"
          , argumentDescription = Just "Redeemer for the 42 typed validator"
          , argumentPurpose = Set.fromList [Spend, Mint, Withdraw, Publish]
          , argumentSchema = definitionRef @Integer
          }
    , validatorDatum = Nothing
    , validatorCompiledCode =
        Just . Short.fromShort $ Lesson03.serializedMk42CustomValidator
    }

read42ValSmall :: ValidatorBlueprint referencedTypes
read42ValSmall =
  MkValidatorBlueprint
    { validatorTitle = "42 datum validator untyped"
    , validatorDescription = Just "Validator that returns true only if the datum is number 42."
    , validatorParameters = []
    , validatorRedeemer =
        MkArgumentBlueprint
          { argumentTitle = Just "Redeemer"
          , argumentDescription = Just "Redeemer for the 42 typed validator"
          , argumentPurpose = Set.fromList [Spend, Mint, Withdraw, Publish]
          , argumentSchema = definitionRef @Integer
          }
    , validatorDatum = Nothing
    , validatorCompiledCode =
        Just . Short.fromShort $ Lesson03.serializedRead42ValidatorSmall
    }

{- -------------------------------------------------------------------------------------------- -}
{- ----------------------------------- VALIDATORS - Lesson05 ---------------------------------- -}

vestingValidator :: ValidatorBlueprint referencedTypes
vestingValidator =
  MkValidatorBlueprint
    { validatorTitle = "Vesting validator"
    , validatorDescription = Just "Validator that allows spending only by a certain key and after a certain deadline"
    , validatorParameters = []
    , validatorRedeemer =
        MkArgumentBlueprint
          { argumentTitle = Just "Redeemer"
          , argumentDescription = Just "Redeemer for the vesting validator"
          , argumentPurpose = Set.singleton Spend
          , argumentSchema = definitionRef @()
          }
    , validatorDatum =
        Just $
          MkArgumentBlueprint
            { argumentTitle = Just "VestingDatum"
            , argumentDescription = Just "Datum for the vesting validator"
            , argumentPurpose = Set.singleton Spend
            , argumentSchema = definitionRef @Vesting.VestingDatum
            }
    , validatorCompiledCode =
        Just . Short.fromShort $ Vesting.serializedVestingVal
    }

vestingValidatorParam :: ValidatorBlueprint referencedTypes
vestingValidatorParam =
  MkValidatorBlueprint
    { validatorTitle = "Parameterized vesting validator"
    , validatorDescription = Just "Validator that allows spending only by a certain key and after a certain deadline"
    , validatorParameters =
        [ MkParameterBlueprint
            { parameterTitle = Just "VestingParam"
            , parameterDescription = Just ""
            , parameterPurpose = Set.singleton Spend
            , parameterSchema = definitionRef @Vesting.VestingParam
            }
        ]
    , validatorRedeemer =
        MkArgumentBlueprint
          { argumentTitle = Just "Redeemer"
          , argumentDescription = Just "Redeemer for the vesting validator"
          , argumentPurpose = Set.singleton Spend
          , argumentSchema = definitionRef @()
          }
    , validatorDatum = Nothing
    , validatorCompiledCode =
        Just . Short.fromShort $ Vesting.serializedParamVestingVal
    }

vestingValidatorMix :: ValidatorBlueprint referencedTypes
vestingValidatorMix =
  MkValidatorBlueprint
    { validatorTitle = "Vesting validator with mixed datum"
    , validatorDescription = Just "Validator that allows spending only by a certain key and after a certain deadline"
    , validatorParameters = []
    , validatorRedeemer =
        MkArgumentBlueprint
          { argumentTitle = Just "Redeemer"
          , argumentDescription = Just "Redeemer for the vesting validator"
          , argumentPurpose = Set.singleton Spend
          , argumentSchema = definitionRef @()
          }
    , validatorDatum =
        Just $
          MkArgumentBlueprint
            { argumentTitle = Just "VestingDatumMix"
            , argumentDescription = Just "Mixed datum for the vesting validator"
            , argumentPurpose = Set.singleton Spend
            , argumentSchema = definitionRef @Vesting.VestingDatumMix
            }
    , validatorCompiledCode =
        Just . Short.fromShort $ Vesting.serializedVestingValMix
    }

{- -------------------------------------------------------------------------------------------- -}
{- ----------------------------------- VALIDATORS - Lesson07 ---------------------------------- -}

signedValidator :: ValidatorBlueprint referencedTypes
signedValidator =
  MkValidatorBlueprint
    { validatorTitle = "Signed minting policy"
    , validatorDescription = Just "Policy that allows minting only when the correct signature is added"
    , validatorParameters =
        [ MkParameterBlueprint
            { parameterTitle = Just "PubKeyHash"
            , parameterDescription = Just ""
            , parameterPurpose = Set.singleton Spend
            , parameterSchema = definitionRef @PubKeyHash
            }
        ]
    , validatorRedeemer =
        MkArgumentBlueprint
          { argumentTitle = Just "Redeemer"
          , argumentDescription = Nothing
          , argumentPurpose = Set.singleton Mint
          , argumentSchema = definitionRef @()
          }
    , validatorDatum = Nothing
    , validatorCompiledCode =
        Just . Short.fromShort $ Minting.serializedSignedVal
    }

nftValidator :: ValidatorBlueprint referencedTypes
nftValidator =
  MkValidatorBlueprint
    { validatorTitle = "NFT minting policy"
    , validatorDescription = Just "Policy that allows spending only once and only to mint one token"
    , validatorParameters =
        [ MkParameterBlueprint
            { parameterTitle = Just "TxOutRef"
            , parameterDescription = Just "Reference to the UTxO to consume to be able to mint the NFT"
            , parameterPurpose = Set.singleton Mint
            , parameterSchema = definitionRef @TxOutRef
            }
        , MkParameterBlueprint
            { parameterTitle = Just "TokenName"
            , parameterDescription = Just "NFT's token name"
            , parameterPurpose = Set.singleton Mint
            , parameterSchema = definitionRef @TokenName
            }
        ]
    , validatorRedeemer =
        MkArgumentBlueprint
          { argumentTitle = Just "Redeemer"
          , argumentDescription = Nothing
          , argumentPurpose = Set.singleton Mint
          , argumentSchema = definitionRef @()
          }
    , validatorDatum = Nothing
    , validatorCompiledCode =
        Just . Short.fromShort $ Minting.serializedNFTVal
    }

nftImgValidator :: ValidatorBlueprint referencedTypes
nftImgValidator =
  MkValidatorBlueprint
    { validatorTitle = "NFT image minting policy"
    , validatorDescription = Just "Policy that allows minting a NFT with an embedded image"
    , validatorParameters =
        [ MkParameterBlueprint
            { parameterTitle = Just "TxOutRef"
            , parameterDescription = Just "Reference to the UTxO to consume to be able to mint the NFT"
            , parameterPurpose = Set.singleton Mint
            , parameterSchema = definitionRef @TxOutRef
            }
        ]
    , validatorRedeemer =
        MkArgumentBlueprint
          { argumentTitle = Just "Redeemer"
          , argumentDescription = Nothing
          , argumentPurpose = Set.singleton Mint
          , argumentSchema = definitionRef @()
          }
    , validatorDatum = Nothing
    , validatorCompiledCode =
        Just . Short.fromShort $ Minting.serializedNftImgVal
    }