from env_gridworld import action_grid, state_grid, env_gridworld
# from env_simplifiedMFM import action_SMFM, state_SMFM, env_SMFM
# from env_SFR_Simplified import action_SFR_Simp, state_SFR_Simp, env_SFR_Simplified
# from env_SFR_Simplified2 import env_SFR_Simplified2
# from env_SFR_H2 import state_EFlow, state_MFlow, state_SFR_H2, action_SFR_H2, state_valve, env_SFR_H2
# from env_MFM_Paper_badMotor import action_paper, state_I_cont_paper, state_M_BoP_paper, state_H_Mot_paper, state_MFM_Paper, env_MFM_Paper_badMotor
from env_MFM_Paper_goodMotor import action_paper, state_I_cont_paper, state_M_BoP_paper, state_H_Mot_paper, state_MFM_Paper, env_MFM_Paper_goodMotor
from learningstrategy_mqbase import learningstrategy_mqbase
from learningstrategy_mdp import learningstrategy_mdp
from learningstrategy_qlearning import learningstrategy_qlearning

def main():
    # environment = env_MFM_Paper_badMotor()
    environment = env_MFM_Paper_goodMotor()
    discount = 1.0
    max_iter = 10

    MDP_agent = learningstrategy_mdp(environment, discount, max_iter)
    MDP_agent.train_model()
    """
    epsilon = 1.0
    learningrate = 1.0
    QL_agent = learningstrategy_qlearning(environment, \
        discount, max_iter, epsilon, learningrate)
    QL_agent.train_model()
    """
    #environment.plot_V_values(MDP_agent.V_value_table)

    return

main()
