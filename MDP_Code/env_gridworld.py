from env_base import action_base, state_base, env_base

# actions in gridworld environment
# directions the agent can go
class action_grid(action_base):
    """
    variables:
        self.dir, possible values: 'N', 'S', 'W', 'E', "EXIT"
    """
    def __init__(self, val):
        if(val != "N" \
            and val != "S" \
            and val != "W" \
            and val != "E" \
            and val != "EXIT"):
            print("action_grid: illegal action.  Should be N/S/W/E/EXIT")
        self.dir = val;
        return

    def GetStringVal(self):
        return self.dir;

# states in gridworld environment
# coordinate in the gridworld
class state_grid(state_base):
    """
    variables:
        self.x
        self.y
    """
    def __init__(self, x, y):
        self.x = x;
        self.y = y;
        return

    def GetXYVal(self):
        return self.x, self.y

    def GetStringVal(self):
        return "x" + str(self.x) + "y" + str(self.y)

class env_gridworld(env_base):
    """
    variables:
        self.problem_map,  map of the gridworld
        self.rewards_map,  reward value of each position
        self.prob_correct, probability of moving as planned.
    """
    def __init__(self, problem_map, rewards_map, prob):
        self.problem_map = problem_map
        self.rewards_map = rewards_map
        self.prob_correct = prob

        self.State_Table = {}
        self.StatesLoaded = False;
        # the probability to move to state state_strN if action action_str is
    	# taken at this_state_str is probN
    	# TransitionMatrix[state_str][action_str] = {state_str1: prob1, state_str2: prob2, ..}
        self.TransitionMatrix = {};
        #initial V values. for iterations starting with user defined V's.
        self.initial_V_table = {};
        return;

    def load_all_state(self):
        # prepare State_Table and TransitionMatrix
        for j in range(0, len(self.problem_map)):
            for i in range(0, len(self.problem_map[0])):
            	# "X" means it is a block
                if(self.problem_map[j][i] != "X" and self.problem_map[j][i] != "X"):
                    this_state = state_grid(i, j)
                    this_state_str = this_state.GetStringVal()
                    #State_Table
                    self.State_Table[this_state_str] = this_state
                    #TransitionMatrix
                    action_str_list = {}
                    self.TransitionMatrix[this_state_str] = action_str_list

                    if(self.is_terminal(this_state)):
                    	# terminal state has only one legal action: "EXIT".
                        action_exit = action_grid("EXIT")
                        self.TransitionMatrix[this_state_str][action_exit.GetStringVal()] \
                            = {this_state_str : 1.0}
                    else:
                        action_list = self.calc_LegalActions(this_state);

                        # loop over possible actions at the current state
                        for i_action in range(len(action_list)):
                            this_action = action_list[i_action];
                            this_action_str = this_action.GetStringVal();
                            self.TransitionMatrix[this_state_str][this_action_str] = {}
                            next_states, next_probs = self.calc_NextState_states_probs(this_state, this_action);

                            # loop over all possible next states given current state and action
                            for i_NextState in range(len(next_states)):
                                next_state_str = next_states[i_NextState].GetStringVal()
                                next_prob = next_probs[i_NextState]
                                if(next_state_str not in self.TransitionMatrix[this_state_str][this_action_str].keys()):
                                	# the key (current state, action, next state) is firstly seen
                                    self.TransitionMatrix[this_state_str][this_action_str][next_state_str] = next_prob
                                else:
                                	# the key (current state, action, next state) is not firstly seen
                                	# an example of triggering this scenarion:
                                	# Consider a position where its west and east sides are both blocked.
                                	# if action "N" is taken, the agent has 10% chance to slide to west and 10% to east.
                                	# However, since  west and east are blocked, either scenarions will stay stationary.
                                	# Thus (current state, "N", current state) will appear twice and will have a 10%+10% prob.
                                    self.TransitionMatrix[this_state_str][this_action_str][next_state_str] += next_prob

        self.StatesLoaded = True;
        return;

    def plot_policy(self, policy_table):
    	# plot the policy map
        # policy_table[state_str] = optimal policy
        for j in range(0, len(self.problem_map)):
            for i in range(0, len(self.problem_map[0])):
                state_str = "x" + str(i) + "y" + str(j)
                if state_str in policy_table.keys():
                    print(policy_table[state_str]),
                else:
                    print(self.problem_map[j][i]),
            print(" ")
        return;

    def plot_V_values(self, V_value_table):
    	# plot the v value map
        # V_value_table[state_str] = v_value
        # policy_table[state_str] = optimal policy
        for j in range(0, len(self.problem_map)):
            for i in range(0, len(self.problem_map[0])):
                state_str = "x" + str(i) + "y" + str(j)
                if state_str in V_value_table.keys():
                    print(round(V_value_table[state_str], 3)), "\t",
                else:
                    print(self.problem_map[j][i], "\t"),
            print(" ")
        return

    def plot_Q_values(self, Q_value_table):
    	# not implemented yet
        # Q_value_table[state][action] = Q_value
        # no return value
        pass;

    def calc_LegalActions(self, state):
    	# find the legal actions can be taken at state explicitly
        if(self.is_terminal(state)):
            return [action_grid("EXIT")]

        return [action_grid("N"), action_grid("E"), \
                action_grid("S"), action_grid("W")]

    def LegalActions(self, state):
    	# find the legal actions can be taken using the loaded transition matrix
		# if transition matrix is not loaded, call calc_LegalActions to find legal actions explicitly
        # return an array of legal actions
        if(self.StatesLoaded == False):
            return self.calc_LegalActions(state);

        action_list = []
        state_str = state.GetStringVal()
        if(state_str not in self.TransitionMatrix):
            print("No requested state found in transitionmatrix")
            return action_list
        for action_str in self.TransitionMatrix[state_str]:
            action_list.append(action_grid(action_str))

        return action_list

    def GetReward(self, state, action, next_state):
        # return the value in rewards_map with coordinate of state.
    	# If state_ptr is a terminal state, the reward/penalty of reaching state is given
    	# If not, GetReward gives the costs of taking "action" (flat 0.01 in this demo)
    	# next_state is a dummy variable for env_gridworld's GetReward
        # note: gridworld does not use pre-loaded TransitionMatrix
        #  because the transition is simple enough and online calculation is good.
        StateX, StateY = state.GetXYVal()
        return self.rewards_map[StateY][StateX]

    def calc_NextState_states_probs(self, state, action):
    	# finds possible next states and corresponding probabilities explicitly
        # return an array of all the possible next states
        # and the array of corresponding possibilitie

        next_states = [];
        next_probs = [self.prob_correct, \
                        0.5 - (self.prob_correct) / 2.0, \
                        0.5 - (self.prob_correct) / 2.0];

        StateX, StateY = state.GetXYVal();

        if(action.GetStringVal() == "N"):
            #0.8 north
            if(StateY == 0):
                next_states.append(state_grid(StateX, StateY));
            elif (self.problem_map[StateY - 1][StateX] == "X" \
                     or self.problem_map[StateY - 1][StateX] == "x"):
                next_states.append(state_grid(StateX, StateY));
            else:
                next_states.append(state_grid(StateX, StateY - 1));

            #0.1 west
            if(StateX == 0):
                next_states.append(state_grid(StateX, StateY));
            elif (self.problem_map[StateY][StateX - 1] == "X" \
                     or self.problem_map[StateY][StateX - 1] == "x"):
                next_states.append(state_grid(StateX, StateY));
            else:
                next_states.append(state_grid(StateX - 1, StateY));

            #0.1 east
            if(StateX == len(self.problem_map[0]) - 1):
                next_states.append(state_grid(StateX, StateY));
            elif (self.problem_map[StateY][StateX + 1] == "X" \
                     or self.problem_map[StateY][StateX + 1] == "x"):
                next_states.append(state_grid(StateX, StateY));
            else:
                next_states.append(state_grid(StateX + 1, StateY));

        elif(action.GetStringVal() == "S"):
            #0.8 south
            if(StateY == len(self.problem_map) - 1):
                next_states.append(state_grid(StateX, StateY));
            elif (self.problem_map[StateY + 1][StateX] == "X" \
                    or self.problem_map[StateY + 1][StateX] == "x"):
                next_states.append(state_grid(StateX, StateY));
            else:
                next_states.append(state_grid(StateX, StateY + 1));

            #0.1 west
            if(StateX == 0):
                next_states.append(state_grid(StateX, StateY));
            elif (self.problem_map[StateY][StateX - 1] == "X" \
                     or self.problem_map[StateY][StateX - 1] == "x"):
                next_states.append(state_grid(StateX, StateY));
            else:
                next_states.append(state_grid(StateX - 1, StateY));

            #0.1 east
            if(StateX == len(self.problem_map[0]) - 1):
                next_states.append(state_grid(StateX, StateY));
            elif (self.problem_map[StateY][StateX + 1] == "X" \
                     or self.problem_map[StateY][StateX + 1] == "x"):
                next_states.append(state_grid(StateX, StateY));
            else:
                next_states.append(state_grid(StateX + 1, StateY));

        elif(action.GetStringVal() == "W"):
            #0.8 west
            if(StateX == 0):
                next_states.append(state_grid(StateX, StateY));
            elif (self.problem_map[StateY][StateX - 1] == "X" \
                     or self.problem_map[StateY][StateX - 1] == "x"):
                next_states.append(state_grid(StateX, StateY));
            else:
                next_states.append(state_grid(StateX - 1, StateY));

            #0.1 north
            if(StateY == 0):
                next_states.append(state_grid(StateX, StateY));
            elif (self.problem_map[StateY - 1][StateX] == "X" \
                     or self.problem_map[StateY - 1][StateX] == "x"):
                next_states.append(state_grid(StateX, StateY));
            else:
                next_states.append(state_grid(StateX, StateY - 1));

            #0.1 south
            if(StateY == len(self.problem_map) - 1):
                next_states.append(state_grid(StateX, StateY));
            elif (self.problem_map[StateY + 1][StateX] == "X" \
                     or self.problem_map[StateY + 1][StateX] == "x"):
                next_states.append(state_grid(StateX, StateY));
            else:
                next_states.append(state_grid(StateX, StateY + 1));

        elif(action.GetStringVal() == "E"):
            #0.8 East
            if(StateX == len(self.problem_map[0]) - 1):
                next_states.append(state_grid(StateX, StateY));
            elif (self.problem_map[StateY][StateX + 1] == "X" \
                     or self.problem_map[StateY][StateX + 1] == "x"):
                next_states.append(state_grid(StateX, StateY));
            else:
                next_states.append(state_grid(StateX + 1, StateY));

            #0.1 north
            if(StateY == 0):
                next_states.append(state_grid(StateX, StateY))
            elif (self.problem_map[StateY - 1][StateX] == "X" \
                     or self.problem_map[StateY - 1][StateX] == "x"):
                next_states.append(state_grid(StateX, StateY));
            else:
                next_states.append(state_grid(StateX, StateY - 1));

            #0.1 south
            if(StateY == len(self.problem_map) - 1):
                next_states.append(state_grid(StateX, StateY));
            elif (self.problem_map[StateY + 1][StateX] == "X" \
                     or self.problem_map[StateY + 1][StateX] == "x"):
                next_states.append(state_grid(StateX, StateY));
            else:
                next_states.append(state_grid(StateX, StateY + 1));
        else:
            print("illegal act encountered")

        return next_states, next_probs

    def NextState_states_probs(self, state, action):
        # return possible next states and corresponding probs
        # if taking action action at state
    	# It finds these states from the transition matrix if it is loaded.
    	# if TM is not loaded, it calls calc_NextState_states_probs
        if(self.StatesLoaded == False):
            return self.calc_NextState_states_probs(state, action);

        next_states = []
        next_probs = []

        State_str = state.GetStringVal();
        Action_str = action.GetStringVal();
        if(State_str not in self.TransitionMatrix.keys()):
            print("NextStateProb: State not in transitionmatrix")
            return [], []


        if(Action_str not in self.TransitionMatrix[State_str].keys()):
            print("illegal actions in NextState_states_probs")
            return [], []

        for next_state_str in self.TransitionMatrix[State_str][Action_str]:
            next_states.append(self.State_Table[next_state_str])
            next_probs.append(self.TransitionMatrix[State_str][Action_str][next_state_str])


        return next_states, next_probs

    #provide an initial state to the learning agent
    def starting_state(self):
        return state_grid(0, 2);

    def is_terminal(self, state):
        # if the state is the terminal
        if(not isinstance(state, state_grid)):
            return False;
        StateX, StateY = state.GetXYVal();
        if(self.problem_map[StateY][StateX] == "0"):
            return False;
        return True;

