from env_base import action_base, state_base, env_base
from env_gridworld import action_grid, state_grid, env_gridworld

class learningstrategy_mqbase(object):
    """
    variables

    self.policy_table.  policy_table[state_str] = action_str

    Table of Q values calculated by the most recent completed iteration.
    self.Q_value_table. Q_value_table[state][action] = Q_val

    Q values calculated in the ongoing(current) iteration
    self.updated_Q_table

    table of V values
    self.V_value_table. policy_table[state_str] = V_value

    the environment to be explored
    self.environment.

    self.discount    //gamma

    self.max_iter
    """
    def __init__(self, environment, discount, max_iter):
        self.policy_table = {}
        self.Q_value_table = {};
        self.V_value_table = {}
        self.updated_Q_table = {};
        self.environment = environment
        self.discount = discount
        self.max_iter = max_iter

    def calc_Q_value(self, state, action):
    	# Q(s, a) = Sum T(s, a, s')[R(s, a, s') + discount * V(s')] over s'
        next_states, next_probs = \
            self.environment.NextState_states_probs(state, action)
        Q_val = 0.0
        for i in range(0, len(next_probs)):
            next_state = next_states[i]
            next_prob = next_probs[i]
            optimal_action_next, V_val_next \
                = self.get_optimal_action_n_V_value(next_state);

            Q_val = Q_val + next_prob * \
                (self.environment.GetReward(state, action, next_state) + \
                self.discount * V_val_next)

        return Q_val;

    def set_Q_value_in_updated_table(self, state, action, val):
    	# update updated_Q_table such that updated_Q_table[state_str][action_str] = val
        state_str = state.GetStringVal()
        action_str = action.GetStringVal()
        if state_str not in self.updated_Q_table.keys():
            action_table = {}
            self.updated_Q_table[state_str] = action_table

        self.updated_Q_table[state_str][action_str] = val;
        return;


    def get_Q_value(self, state, action):
    	# get the Q(s, a) value from Q_value_table (not updated_Q_table). i.e.
    	# return Q_value_table[state_str][action_str]
    	# also initialize Q_value_table[state_str][action_str] to 0 if not set before
        state_str = state.GetStringVal()
        action_str = action.GetStringVal()

        if state_str not in self.Q_value_table.keys():
            action_table = {}
            self.Q_value_table[state_str] = action_table

        if action_str not in self.Q_value_table[state_str].keys():
            self.Q_value_table[state_str][action_str] = 0.0;

        return self.Q_value_table[state_str][action_str];

    def updated_Q_table_to_Q_table(self):
    	# iterate over updated_Q_value_table to
		# move Q values in updated_Q_value_table to Q_value_table
		# and reset the updated_Q_value_table to empty.
    	# this function is only called at the end of each iteration.
        for state_str, action_list in self.updated_Q_table.items():
            for action_str, Q_val in action_list.items():
                if state_str not in self.Q_value_table.keys():
                    action_table = {}
                    self.Q_value_table[state_str] = action_table
                self.Q_value_table[state_str][action_str] = Q_val;

        for state_str, action_list in self.updated_Q_table.items():
            action_list.clear();
        self.updated_Q_table.clear();
        return;

    def get_optimal_action_n_V_value(self, state):
    	# return the action a that gives the maximum Q(s, a) at state s
    	# and the corresponding Q(s, a), which is V(s)
        action_arr = self.environment.LegalActions(state)
        if(len(action_arr) == 0):
            print("state", state.index, state.GetStringVal(), "has no legal action.  V = 0")
            return action_base(), 0;

        best_a = 0;
        best_Q = self.get_Q_value(state, action_arr[0])

        for i in range(1, len(action_arr)):
            this_Q = self.get_Q_value(state, action_arr[i])
            if(this_Q > best_Q):
                best_a = i;
                best_Q = this_Q
        return action_arr[best_a], best_Q


    def load_V_table_n_policy_table_from_Q_table_helper(self, this_state):
    	# recursively traverse over all the states and actions to udpate the
		# policy table and V table from the values in Q_value_table
        optimal_action, V_val = self.get_optimal_action_n_V_value(this_state)
        self.policy_table[this_state.GetStringVal()] \
            = optimal_action.GetStringVal()
        self.V_value_table[this_state.GetStringVal()] \
            = V_val

        if(self.environment.is_terminal(this_state)):
        	# terminate the recursion if terminal state is reached
            return;

        actions_list = self.environment.LegalActions(this_state)
        for a in range(len(actions_list)):
        	# loop over all possible actions and potential next states
            this_action = actions_list[a]
            next_states, next_probs = \
                self.environment.NextState_states_probs(this_state, this_action)
            for i in range(0, len(next_states)):
                next_state = next_states[i]
                state_str = next_state.GetStringVal();
                if state_str not in self.V_value_table.keys():
                	# recursively search the next state
                    self.load_V_table_n_policy_table_from_Q_table_helper(next_state);


    def load_V_table_n_policy_table_from_Q_table(self):
    	# update the policy_table and V_value_table using the Q_value_table
		# called at the end of the entire training process to prepare for the plot step.
        self.V_value_table.clear();
        self.policy_table.clear();
        current_state = self.environment.starting_state();
        self.load_V_table_n_policy_table_from_Q_table_helper(current_state);
        return;

    def train_model(self):
        pass
