import random
from learningstrategy_mqbase import learningstrategy_mqbase

class learningstrategy_qlearning(learningstrategy_mqbase):
    """
        protected variables
        self.epsilon
        self.LearningRate
        and other projtected in base class
    """
    def __init__(self, environment, discount, max_iter, epsilon, LearningRate):
        self.epsilon = epsilon
        self.LearningRate = LearningRate
        super(learningstrategy_qlearning, self).__init__(environment, discount, max_iter)


    def actual_next_state(self, this_state, this_action):
    	# sample the actual next state from all possible next states
    	# randomly sampled from all possible next states bsaed upon corresponding probs

    	# get the possible next states and corresponding transition probabilities
    	# at the current state and action
        next_states, next_probs = \
            self.environment.NextState_states_probs(this_state, this_action)

        if(len(next_states) == 0 or (len(next_states) != len(next_probs))):
            print("wrong next states and probabilities information")
            return state_base()

        # sample the actual next state
        Seed = random.uniform(0, 1)
        actual_i = 0;
        cum_prob = next_probs[0]
        while(cum_prob < Seed):
            actual_i = actual_i + 1;
            cum_prob = cum_prob + next_probs[actual_i]

        return next_states[actual_i];

    def get_random_action(self, state):
    	# randomly choose an action. Used for exploration in q-learning
        action_list = self.environment.LegalActions(state)
        if(len(action_list) == 0):
            print("no random actions available")
            return action_base()

        Seed = random.uniform(0, 1)
        actual_i = 0;
        while((actual_i + 1.0) / len(action_list) < Seed):
            actual_i = actual_i + 1

        return action_list[actual_i]

    #sample = R(s, a, s') + discount * max_a'{Q(s', a')}
    def Q_sample_val(self, this_state, this_action, next_state):
        next_state_best_action, next_state_v_value = \
            self.get_optimal_action_n_V_value(next_state)
        return self.environment.GetReward(this_state, this_action, next_state) \
            + self.discount * next_state_v_value

    #Q(s, a) = (1 - alpha) * Q(s, a) + alpha * sample
    def new_Q_val_from_sample(self, state, action, next_state):
        Q_sample = self.Q_sample_val(state, action, next_state)
        return (1.0 - self.LearningRate) * self.get_Q_value(state, action) \
            + self.LearningRate * Q_sample

    def update_LearningRate(new_LR):
        self.LearningRate = new_LR;
        return

    def train_model(self):
        for episode in range (0, self.max_iter):
            print("episode", episode, " start...")
            current_state = self.environment.starting_state();
            while(self.environment.is_terminal(current_state) == False):
                this_action = self.get_random_action(current_state)

                Seed = random.uniform(0, 1)
                if(Seed < self.epsilon):
                    #explore
                    this_action = self.get_random_action(current_state)
                else:
                    #exploit
                    this_action, V_val = self.get_optimal_action_n_V_value(current_state)

                next_state = self.actual_next_state(current_state, this_action)

                #print this_action.GetStringVal(), next_state.GetStringVal(),

                #update Q value
                """
                Below are two different ways of updating Q values.
                See the corresponding function implementations for descriptions.
                """
                New_Q = self.new_Q_val_from_sample(current_state, this_action, next_state)
                #New_Q = self.calc_Q_value(current_state, this_action)
                self.set_Q_value_in_updated_table(current_state, this_action, New_Q)


                #update V value and policy
                optimal_action, V_val = self.get_optimal_action_n_V_value(current_state)
                self.policy_table[current_state.GetStringVal()] \
                    = optimal_action.GetStringVal()
                self.V_value_table[current_state.GetStringVal()] \
                    = V_val

                #increment state
                current_state = next_state

            #print ""
            #assign terminal states' q values
            if(self.environment.is_terminal(current_state)):
                action_list = self.environment.LegalActions(current_state)
                if(len(action_list) == 0):
                    print("no legal actions")

                for i in range(0, len(action_list)):
                    self.set_Q_value_in_updated_table(current_state, action_list[i], \
                        self.environment.GetReward(current_state, action_list[i], current_state))

                #update V value and policy
                optimal_action, V_val = self.get_optimal_action_n_V_value(current_state)
                self.policy_table[current_state.GetStringVal()] \
                    = optimal_action.GetStringVal()
                self.V_value_table[current_state.GetStringVal()] \
                    = V_val

            self.updated_Q_table_to_Q_table()

            self.epsilon = max(0.0, self.epsilon - 1.0 / self.max_iter)
            self.LearningRate = max(0.0, self.LearningRate - 1.0 / self.max_iter)

        #update V_value table and policy table
        self.load_V_table_n_policy_table_from_Q_table()

        self.environment.plot_policy(self.policy_table)
        self.environment.plot_V_values(self.V_value_table)

        return
