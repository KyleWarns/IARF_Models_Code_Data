# base class of actions
class action_base:
    def __init__(self):
        print("action base is called")
        return
    def GetStringVal(self):
        return;

# base class of states
class state_base:
    def __init__(self):
        print("state base is called")
        return
    def GetStringVal(self):
        return

class env_base:
    def __init__(self):
        pass;

    def load_all_state(self):
        # return a list of all states of the problem
        # must be called if MDP is used
        pass;

    def plot_policy(self, policy_table):
        # policy_table[state] = optimal policy
        #no return value
        pass;

    def plot_V_values(self, V_value_table):
        # V_value_table[state] = v_value
        # no return value
        pass;

    def plot_Q_values(self, Q_value_table):
        # Q_value_table[state][action] = Q_value
        # no return value
        pass;

    def LegalActions(self, state):
        # return an array of legal actions
        pass;

    def GetReward(self, state, action, next_state):
        # return the reward/cost value of taking the step
        # if it is the terminal state, return the reward of the state (V_value)
        pass;

    def NextState_states_probs(self, state, action):
        # return an array of all the possible next states
        pass;

    	# provide an initial state to the learning agent
    def starting_state(self):
        pass;

    def is_terminal(self, state):
        # if the state is the terminal
        pass;