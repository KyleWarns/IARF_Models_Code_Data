from learningstrategy_mqbase import learningstrategy_mqbase

class learningstrategy_mdp(learningstrategy_mqbase):
    def __init__(self, environment, discount, max_iter):
        super(learningstrategy_mdp, self).__init__(environment, discount, max_iter)

    def train_model(self):
    	# call load_all_state to load transition matrix and state table
        self.environment.load_all_state()
        State_Table = self.environment.State_Table

        #using initial V value if supplied by user
        if(len(self.environment.initial_V_table) != 0):
            for s in State_Table:
                this_state = State_Table[s]
                actions_list = self.environment.LegalActions(this_state)
                this_init_V_s = self.environment.initial_V_table[s];
                for a in range(len(actions_list)):
                    this_action = actions_list[a]
                    self.set_Q_value_in_updated_table(this_state, this_action, this_init_V_s);
            self.updated_Q_table_to_Q_table()

        """
        for s in State_Table:
            this_state = State_Table[s]
            actions_list = self.environment.LegalActions(this_state)
            for a in range(len(actions_list)):
                this_action = actions_list[a]

                print(this_state.GetStringVal(), this_action.GetStringVal(), \
                    self.get_Q_value(this_state, this_action))

        """

        #optimize Q value
        for episode in range(self.max_iter):
            print("episode", episode)
            for s in State_Table:
            	# iterate over all the states in state_table
                this_state = State_Table[s]
                actions_list = self.environment.LegalActions(this_state)
                for a in range(len(actions_list)):
                    this_action = actions_list[a]
                    New_Q = 0.0
                    if(self.environment.is_terminal(this_state)):
                    	# if this state is a terminal state
                    	# its Q value is just the reward/penalty of getting this state.
                    	# Note: IN this case, the only possible action would be "exit",
                    	# so it's OK to put it inside the action loop
                        New_Q = self.environment.GetReward(this_state, this_action, this_state)
                    else:
                    	# if this state is not a terminal state
                    	# calculate its Q value based on action costs & v values of following possible states
                        New_Q = self.calc_Q_value(this_state, this_action)
                    #print(this_state.GetStringVal(), this_action.GetStringVal(), New_Q)
                    self.set_Q_value_in_updated_table(this_state, this_action, New_Q)
                    """
                    if(this_state.get_index() == 1):
                        print(this_action.GetStringVal(),New_Q)
                    """
            # update the updated_Q_value_table
            self.updated_Q_table_to_Q_table()

        #update V value for policy plot
        for s in State_Table:
            this_state = State_Table[s]
            optimal_action, V_val = self.get_optimal_action_n_V_value(this_state)
            self.policy_table[this_state.GetStringVal()] = optimal_action.GetStringVal()
            self.V_value_table[this_state.GetStringVal()] = V_val

        self.environment.print_transitionmatrix(self.Q_value_table, self.V_value_table);
        return;
