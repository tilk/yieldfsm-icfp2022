module FSM.ICFP2022.Updn where

import Clash.Prelude
import Clash.Annotations.TH
import qualified FSM.ICFP2022.Examples as E

updn :: "clk" ::: Clock System
     -> "rst" ::: Reset System
     -> "en"  ::: Enable System
     -> "i"  ::: Signal System (Bool, Bool)
     -> "o"  ::: Signal System (Unsigned 2)
updn = exposeClockResetEnable $ E.updn
makeTopEntity 'updn

updn_fixed :: "clk" ::: Clock System
           -> "rst" ::: Reset System
           -> "en"  ::: Enable System
           -> "i"  ::: Signal System (Bool, Bool)
           -> "o"  ::: Signal System (Unsigned 2)
updn_fixed = exposeClockResetEnable $ E.updn_fixed
makeTopEntity 'updn_fixed


