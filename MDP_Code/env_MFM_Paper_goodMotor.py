from env_base import action_base, state_base, env_base
from collections import deque


class action_paper(action_base):
	def __init__(self, action_name):
		# "100%"
		# "80%"
		# "0%"
		self.action_name = action_name;

	def GetStringVal(self):
		# return the action name
		return self.action_name;

class state_I_cont_paper:
	def __init__(self, index):
		self.index = index;
	def get_index(self):
		return self.index;
	def GetStringVal(self):
		return str(self.index)

class state_M_BoP_paper:
	def __init__(self, index):
		self.index = index;
	def get_index(self):
		return self.index;
	def GetStringVal(self):
		return str(self.index)

class state_H_Mot_paper:
	def __init__(self, index):
		self.index = index;
	def get_index(self):
		return self.index;
	def GetStringVal(self):
		return str(self.index)

class state_MFM_Paper(state_base):
	def __init__(self, index, time, \
				M_BoP, H_Mot, I_cont):
		self.index = index;
		self.time = time;
		self.M_BoP = M_BoP
		self.H_Mot = H_Mot;
		self.I_cont = I_cont;
		return;

	def get_index(self):
		return self.index

	def GetStringVal(self):
		#return a string consisting of the parameters (such as what I did for gridworld)
		return "time" + str(self.time) \
			+ "M_BoP" + self.M_BoP.GetStringVal() \
			+ "H_Mot" + self.H_Mot.GetStringVal() \
			+ "I_cont" + self.I_cont.GetStringVal()

class env_MFM_Paper_goodMotor(env_base):
	def __init__(self):
		#hashtable State_Table such that State_Table[state.GetStringVal()] = state
		self.State_Table = {}

		action_100 = action_paper("100%");
		action_80 = action_paper("80%");
		action_list = [action_100, action_80]
		action_exit = action_paper("EXIT")

		# M_BoP
		M_BoP1 = state_M_BoP_paper(1);
		M_BoP2 = state_M_BoP_paper(2);
		M_BoP3 = state_M_BoP_paper(3);

		# M_BoP_Table[M_BoP.GetStringVal()] = M_BoP
		self.M_BoP_Table = {M_BoP1.GetStringVal(): M_BoP1, \
							M_BoP2.GetStringVal(): M_BoP2, \
							M_BoP3.GetStringVal(): M_BoP3}
		self.M_BoP_arr = [M_BoP1, M_BoP2, M_BoP3]


		#motor health status
		H_Mot1 = state_H_Mot_paper(1);
		H_Mot2 = state_H_Mot_paper(2);
		H_Mot3 = state_H_Mot_paper(3);

		# H_Mot_Table[H_Mot1.GetStringVal()] = H_Mot1
		self.H_Mot_Table = {H_Mot1.GetStringVal(): H_Mot1, \
							H_Mot2.GetStringVal(): H_Mot2, \
							H_Mot3.GetStringVal(): H_Mot3}
		self.H_Mot_arr = [H_Mot1, H_Mot2, H_Mot3]


		# i_cont
		I_Cont1 = state_I_cont_paper(1);
		I_Cont2 = state_I_cont_paper(2);
		I_Cont3 = state_I_cont_paper(3);
		self.I_Cont_Table = {I_Cont1.GetStringVal(): I_Cont1, \
							I_Cont2.GetStringVal(): I_Cont2, \
							I_Cont3.GetStringVal(): I_Cont3}
		self.I_Cont_arr = [I_Cont1, I_Cont2, I_Cont3]

		#TransitionMatrix[state_str][action_str] = {state_str1: prob1, state_str2: prob2, ..}
		#Check env_gridworld.py for how it is implemented and used.
		self.TransitionMatrix = {};
		#whether State_Table and TransitionMatrix are set up.
		self.initial_V_table = {};
		#initial V values. for iterations starting with user defined V's.
		self.StatesLoaded = False;

		#I_Cont_Matrix[]
		self.I_Cont_Matrix = {}

		# t = 0
		self.I_Cont_Matrix[(H_Mot1.GetStringVal(), action_100.GetStringVal(), 0)]=[ ((I_Cont1, 1), 0.99),                       ((I_Cont3, 1), 0.01)]
		self.I_Cont_Matrix[(H_Mot1.GetStringVal(), 	action_80.GetStringVal(), 0)]=[                       ((I_Cont2, 1), 0.99), ((I_Cont3, 1), 0.01)]

		for t in range(1,3):
			self.I_Cont_Matrix[(H_Mot1.GetStringVal(), action_100.GetStringVal(), t)]=[ ((I_Cont1, t+1), 0.99),                         ((I_Cont3, t+1), 0.01)]
			self.I_Cont_Matrix[(H_Mot2.GetStringVal(), action_100.GetStringVal(), t)]=[ ((I_Cont1, t+1), 0.95),                         ((I_Cont3, t+1), 0.05)]
			self.I_Cont_Matrix[(H_Mot3.GetStringVal(), action_100.GetStringVal(), t)]=[                                                 ((I_Cont3, t+1), 1.00)]
			self.I_Cont_Matrix[(H_Mot1.GetStringVal(), 	action_80.GetStringVal(), t)]=[                         ((I_Cont2, t+1), 0.99), ((I_Cont3, t+1), 0.01)]
			self.I_Cont_Matrix[(H_Mot2.GetStringVal(),  action_80.GetStringVal(), t)]=[                         ((I_Cont2, t+1), 0.95), ((I_Cont3, t+1), 0.05)]
			self.I_Cont_Matrix[(H_Mot3.GetStringVal(), 	action_80.GetStringVal(), t)]=[                         ((I_Cont2, t+1), 0.00), ((I_Cont3, t+1), 1.00)]


	 	#H_Mot_Matrix[]
		self.H_Mot_Matrix = {}

		# t = 0
		self.H_Mot_Matrix[(H_Mot1.GetStringVal(), M_BoP1.GetStringVal(), I_Cont1.GetStringVal(), 0)]=[ 	((H_Mot1, 1), 0.990), ((H_Mot2, 1), 0.010)                     ]
		self.H_Mot_Matrix[(H_Mot1.GetStringVal(), M_BoP1.GetStringVal(), I_Cont2.GetStringVal(), 0)]=[ 	((H_Mot1, 1), 0.999), ((H_Mot2, 1), 0.001)                     ]
		self.H_Mot_Matrix[(H_Mot1.GetStringVal(), M_BoP1.GetStringVal(), I_Cont3.GetStringVal(), 0)]=[ 	                                           ((H_Mot3, 1), 1.000)]

		for t in range(1,3):
			self.H_Mot_Matrix[(H_Mot1.GetStringVal(), M_BoP1.GetStringVal(), I_Cont1.GetStringVal(), t)]=[ 	((H_Mot1, t+1), 0.990), ((H_Mot2, t+1), 0.010)                       ]
			self.H_Mot_Matrix[(H_Mot1.GetStringVal(), M_BoP1.GetStringVal(), I_Cont2.GetStringVal(), t)]=[ 	((H_Mot1, t+1), 0.999), ((H_Mot2, t+1), 0.001)                       ]
			self.H_Mot_Matrix[(H_Mot1.GetStringVal(), M_BoP1.GetStringVal(), I_Cont3.GetStringVal(), t)]=[                                                ((H_Mot3, t+1), 1.00)]
			self.H_Mot_Matrix[(H_Mot1.GetStringVal(), M_BoP2.GetStringVal(), I_Cont1.GetStringVal(), t)]=[ 	((H_Mot1, t+1), 0.95), ((H_Mot2, t+1), 0.05)                       ]
			self.H_Mot_Matrix[(H_Mot1.GetStringVal(), M_BoP2.GetStringVal(), I_Cont2.GetStringVal(), t)]=[ 	((H_Mot1, t+1), 0.98), ((H_Mot2, t+1), 0.02)                       ]
			self.H_Mot_Matrix[(H_Mot1.GetStringVal(), M_BoP2.GetStringVal(), I_Cont3.GetStringVal(), t)]=[                                                ((H_Mot3, t+1), 1.00)]
			self.H_Mot_Matrix[(H_Mot1.GetStringVal(), M_BoP3.GetStringVal(), I_Cont1.GetStringVal(), t)]=[                                                ((H_Mot3, t+1), 1.00)]
			self.H_Mot_Matrix[(H_Mot1.GetStringVal(), M_BoP3.GetStringVal(), I_Cont2.GetStringVal(), t)]=[                                                ((H_Mot3, t+1), 1.00)]
			self.H_Mot_Matrix[(H_Mot1.GetStringVal(), M_BoP3.GetStringVal(), I_Cont3.GetStringVal(), t)]=[                                                ((H_Mot3, t+1), 1.00)]

			self.H_Mot_Matrix[(H_Mot2.GetStringVal(), M_BoP1.GetStringVal(), I_Cont1.GetStringVal(), t)]=[ 	                       ((H_Mot2, t+1), 0.90), ((H_Mot3, t+1), 0.10)]
			self.H_Mot_Matrix[(H_Mot2.GetStringVal(), M_BoP1.GetStringVal(), I_Cont2.GetStringVal(), t)]=[                         ((H_Mot2, t+1), 0.95), ((H_Mot3, t+1), 0.05)]
			self.H_Mot_Matrix[(H_Mot2.GetStringVal(), M_BoP1.GetStringVal(), I_Cont3.GetStringVal(), t)]=[                                                ((H_Mot3, t+1), 1.00)]
			self.H_Mot_Matrix[(H_Mot2.GetStringVal(), M_BoP2.GetStringVal(), I_Cont1.GetStringVal(), t)]=[                         ((H_Mot2, t+1), 0.95), ((H_Mot3, t+1), 0.05)]
			self.H_Mot_Matrix[(H_Mot2.GetStringVal(), M_BoP2.GetStringVal(), I_Cont2.GetStringVal(), t)]=[                         ((H_Mot2, t+1), 0.99), ((H_Mot3, t+1), 0.01)]
			self.H_Mot_Matrix[(H_Mot2.GetStringVal(), M_BoP2.GetStringVal(), I_Cont3.GetStringVal(), t)]=[ 	                                              ((H_Mot3, t+1), 1.00)]
			self.H_Mot_Matrix[(H_Mot2.GetStringVal(), M_BoP3.GetStringVal(), I_Cont1.GetStringVal(), t)]=[ 	                                              ((H_Mot3, t+1), 1.00)]
			self.H_Mot_Matrix[(H_Mot2.GetStringVal(), M_BoP3.GetStringVal(), I_Cont2.GetStringVal(), t)]=[ 	                                              ((H_Mot3, t+1), 1.00)]
			self.H_Mot_Matrix[(H_Mot2.GetStringVal(), M_BoP3.GetStringVal(), I_Cont3.GetStringVal(), t)]=[                                                ((H_Mot3, t+1), 1.00)]

			self.H_Mot_Matrix[(H_Mot3.GetStringVal(), M_BoP1.GetStringVal(), I_Cont1.GetStringVal(), t)]=[                                                ((H_Mot3, t+1), 1.00)]
			self.H_Mot_Matrix[(H_Mot3.GetStringVal(), M_BoP1.GetStringVal(), I_Cont2.GetStringVal(), t)]=[                                                ((H_Mot3, t+1), 1.00)]
			self.H_Mot_Matrix[(H_Mot3.GetStringVal(), M_BoP1.GetStringVal(), I_Cont3.GetStringVal(), t)]=[                                                ((H_Mot3, t+1), 1.00)]
			self.H_Mot_Matrix[(H_Mot3.GetStringVal(), M_BoP2.GetStringVal(), I_Cont1.GetStringVal(), t)]=[                                                ((H_Mot3, t+1), 1.00)]
			self.H_Mot_Matrix[(H_Mot3.GetStringVal(), M_BoP2.GetStringVal(), I_Cont2.GetStringVal(), t)]=[                                                ((H_Mot3, t+1), 1.00)]
			self.H_Mot_Matrix[(H_Mot3.GetStringVal(), M_BoP2.GetStringVal(), I_Cont3.GetStringVal(), t)]=[                                                ((H_Mot3, t+1), 1.00)]
			self.H_Mot_Matrix[(H_Mot3.GetStringVal(), M_BoP3.GetStringVal(), I_Cont1.GetStringVal(), t)]=[                                                ((H_Mot3, t+1), 1.00)]
			self.H_Mot_Matrix[(H_Mot3.GetStringVal(), M_BoP3.GetStringVal(), I_Cont2.GetStringVal(), t)]=[                                                ((H_Mot3, t+1), 1.00)]
			self.H_Mot_Matrix[(H_Mot3.GetStringVal(), M_BoP3.GetStringVal(), I_Cont3.GetStringVal(), t)]=[                                                ((H_Mot3, t+1), 1.00)]

		#M_BoP_Matrix[]
		self.M_BoP_Matrix = {}

		# t = 0
		self.M_BoP_Matrix[(M_BoP1.GetStringVal(), I_Cont1.GetStringVal(), 0)]=[ ((M_BoP1, 1), 1.00)]
		self.M_BoP_Matrix[(M_BoP1.GetStringVal(), I_Cont2.GetStringVal(), 0)]=[ ((M_BoP2, 1), 1.00)]
		self.M_BoP_Matrix[(M_BoP1.GetStringVal(), I_Cont3.GetStringVal(), 0)]=[ ((M_BoP3, 1), 1.00)]

		# t = 1
		self.M_BoP_Matrix[(M_BoP1.GetStringVal(), I_Cont1.GetStringVal(), 1)]=[ ((M_BoP1, 2), 1.00)]
		self.M_BoP_Matrix[(M_BoP1.GetStringVal(), I_Cont2.GetStringVal(), 1)]=[ ((M_BoP2, 2), 1.00)]
		self.M_BoP_Matrix[(M_BoP1.GetStringVal(), I_Cont3.GetStringVal(), 1)]=[ ((M_BoP3, 2), 1.00)]
		self.M_BoP_Matrix[(M_BoP2.GetStringVal(), I_Cont1.GetStringVal(), 1)]=[ ((M_BoP1, 2), 1.00)]
		self.M_BoP_Matrix[(M_BoP2.GetStringVal(), I_Cont2.GetStringVal(), 1)]=[ ((M_BoP2, 2), 1.00)]
		self.M_BoP_Matrix[(M_BoP2.GetStringVal(), I_Cont3.GetStringVal(), 1)]=[ ((M_BoP3, 2), 1.00)]
		self.M_BoP_Matrix[(M_BoP3.GetStringVal(), I_Cont1.GetStringVal(), 1)]=[ ((M_BoP1, 2), 1.00)]
		self.M_BoP_Matrix[(M_BoP3.GetStringVal(), I_Cont2.GetStringVal(), 1)]=[ ((M_BoP2, 2), 1.00)]
		self.M_BoP_Matrix[(M_BoP3.GetStringVal(), I_Cont3.GetStringVal(), 1)]=[ ((M_BoP3, 2), 1.00)]

		# t = 2
		self.M_BoP_Matrix[(M_BoP1.GetStringVal(), I_Cont1.GetStringVal(), 2)]=[ ((M_BoP1, 3), 1.00)]
		self.M_BoP_Matrix[(M_BoP1.GetStringVal(), I_Cont2.GetStringVal(), 2)]=[ ((M_BoP2, 3), 1.00)]
		self.M_BoP_Matrix[(M_BoP1.GetStringVal(), I_Cont3.GetStringVal(), 2)]=[ ((M_BoP3, 3), 1.00)]
		self.M_BoP_Matrix[(M_BoP2.GetStringVal(), I_Cont1.GetStringVal(), 2)]=[ ((M_BoP1, 3), 1.00)]
		self.M_BoP_Matrix[(M_BoP2.GetStringVal(), I_Cont2.GetStringVal(), 2)]=[ ((M_BoP2, 3), 1.00)]
		self.M_BoP_Matrix[(M_BoP2.GetStringVal(), I_Cont3.GetStringVal(), 2)]=[ ((M_BoP3, 3), 1.00)]
		self.M_BoP_Matrix[(M_BoP3.GetStringVal(), I_Cont1.GetStringVal(), 2)]=[ ((M_BoP1, 3), 1.00)]
		self.M_BoP_Matrix[(M_BoP3.GetStringVal(), I_Cont2.GetStringVal(), 2)]=[ ((M_BoP2, 3), 1.00)]
		self.M_BoP_Matrix[(M_BoP3.GetStringVal(), I_Cont3.GetStringVal(), 2)]=[ ((M_BoP3, 3), 1.00)]

		self.total_time_step = 3;

		#reward_table[state_str] = reward value;
		self.reward_table = {};
		#cost_table[action_str] = action cost value;
		self.cost_table = {};

		self.load_all_state();

		return;

	def GetReward(self, state, action, next_state):
		# return the reward/cost value of taking the step
		if(not isinstance(state, state_MFM_Paper)):
			print("wrong state type at MFM Paper")
			return -1000.0;
		if(not isinstance(action, action_paper)):
			print("wrong action type at MFM Paper")
			return -1000.0;

		rewards = 0.0;

		if(state.M_BoP.index == 1):
			rewards += 1.0;
		elif(state.M_BoP.index == 2):
			rewards += 0.8;

		if(state.H_Mot.index == 3):
			rewards -= 100.0;

		return rewards;


	def load_all_state(self):
		#setup self.TransitionMatrix and self.TransitionMatrix
		if(self.StatesLoaded == True):
			return;
		action_100 = action_paper("100%");
		action_80 = action_paper("80%");
		action_list = [action_100, action_80]
		action_exit = action_paper("EXIT")

		index = 1;
		this_time = 0;
		this_M_BoP = self.M_BoP_arr[0]
		this_H_Mot = self.H_Mot_arr[0];
		this_I_Cont = self.I_Cont_arr[0];	#(id, dc)
		this_state = state_MFM_Paper(index, this_time, \
			this_M_BoP, this_H_Mot, this_I_Cont);
		self.State_Table[this_state.GetStringVal()] = this_state;
		index = index + 1;

		next_state_queue = deque();
		next_state_queue.append(this_state);

		# breath first search
		while(len(next_state_queue) != 0):
			this_state = next_state_queue.popleft()
			this_state_str = this_state.GetStringVal();
			if(this_state_str not in self.TransitionMatrix.keys()):
				self.TransitionMatrix[this_state_str] = {}

			this_index = this_state.index;
			this_time = this_state.time;
			this_M_BoP = this_state.M_BoP;
			this_M_BoP_str = this_M_BoP.GetStringVal();
			this_H_Mot = this_state.H_Mot;
			this_H_Mot_str = this_H_Mot.GetStringVal();
			this_I_cont = this_state.I_cont;
			this_I_cont_str = this_I_cont.GetStringVal()

			if(this_time == self.total_time_step):
				#the end state.
				self.TransitionMatrix[this_state_str][action_exit.GetStringVal()] = {this_state_str: 1.0};
				continue;

			for i in range(0, len(action_list)):
				this_action = action_list[i]
				this_action_str = this_action.GetStringVal()

				this_I_Cont_prior = (this_H_Mot_str, this_action_str, this_time)
				if(this_I_Cont_prior not in self.I_Cont_Matrix.keys()):
					continue;

				for i_I_Cont in range(len(self.I_Cont_Matrix[this_I_Cont_prior])):

					next_I_Cont      = self.I_Cont_Matrix[this_I_Cont_prior][i_I_Cont][0][0]
					next_I_Cont_str  = next_I_Cont.GetStringVal()
					next_I_Cont_prob = self.I_Cont_Matrix[this_I_Cont_prior][i_I_Cont][1]

					this_H_Mot_prior = (this_H_Mot_str, this_M_BoP_str, next_I_Cont_str, this_time);
					if(this_H_Mot_prior not in self.H_Mot_Matrix.keys()):
						continue;

					for i_H_Mot in range(len(self.H_Mot_Matrix[this_H_Mot_prior])):
						next_H_Mot = self.H_Mot_Matrix[this_H_Mot_prior][i_H_Mot][0][0]
						next_H_Mot_str = next_H_Mot.GetStringVal();
						next_H_Mot_prob = self.H_Mot_Matrix[this_H_Mot_prior][i_H_Mot][1]

						this_M_BoP_prior = (this_M_BoP_str, next_I_Cont_str, this_time);

						if(this_M_BoP_prior not in self.M_BoP_Matrix.keys()):
							continue;

						for i_M_BoP in range(len(self.M_BoP_Matrix[this_M_BoP_prior])):
							next_M_BoP      = self.M_BoP_Matrix[this_M_BoP_prior][i_M_BoP][0][0];
							next_M_BoP_str  = next_M_BoP.GetStringVal();
							next_M_BoP_prob = self.M_BoP_Matrix[this_M_BoP_prior][i_M_BoP][1];

							temp_state = state_MFM_Paper(index, this_time + 1, next_M_BoP, next_H_Mot, next_I_Cont);
							temp_state_str = temp_state.GetStringVal();

							state_is_new = False;

							if(temp_state_str not in self.State_Table):
								state_is_new = True;
								self.State_Table[temp_state_str] = temp_state;
								#print(index, this_time + 1, next_E_In.temp, \
								#	next_E_BoP.pressure, next_E_BoP.temp, next_M_BoP.massflow, next_I_motor.speed, next_I_SG.Dc)
								index = index + 1;
							next_state = self.State_Table[temp_state_str];
							next_state_str = next_state.GetStringVal();
							#print("SFR Index", index)
							if(state_is_new):
								next_state_queue.append(next_state);

							if(this_action_str not in self.TransitionMatrix[this_state_str].keys()):
								self.TransitionMatrix[this_state_str][this_action_str] = {}

							if(next_state_str not in self.TransitionMatrix[this_state_str][this_action_str].keys()):
								self.TransitionMatrix[this_state_str][this_action_str][next_state_str] = 0.0
							#elif(next_I_motor.speed != 0.0):
							else:
								print("------ following not first time ------")
								print(this_state.index, this_state_str)
								print(this_action_str)
								print(next_state.index, next_state_str)
								print("-----------")

							self.TransitionMatrix[this_state_str][this_action_str][next_state_str] += next_I_Cont_prob * next_H_Mot_prob * next_M_BoP_prob;


		#check transition matrix sum
		for i_state_str in self.TransitionMatrix.keys():
			if(len(self.TransitionMatrix[i_state_str]) == 0):
				print("ghost state", self.State_Table[i_state_str].index)
			for i_action_str in self.TransitionMatrix[i_state_str].keys():
				this_sum = 0.0;
				for i_next_state_str in self.TransitionMatrix[i_state_str][i_action_str].keys():
					this_sum += self.TransitionMatrix[i_state_str][i_action_str][i_next_state_str]
				#if(this_sum != 1.0):
				print(i_state_str, i_action_str, this_sum);

		self.StatesLoaded = True;
		return;




	def starting_state(self):
		#provide an initial state to the learning agent
		return state_MFM_Paper(1, 0, \
			state_M_BoP_paper(1), state_H_Mot_paper(1), state_I_cont_paper(1));

	def is_terminal(self, state):
		# if the state is the terminal
		if(not isinstance(state, state_MFM_Paper)):
			return False;

		#check failure state
		action_list = self.LegalActions(state);
		if((len(action_list) == 1) and (action_list[0].GetStringVal() == "EXIT")):
			return True;

		#check final state
		if(state.time != self.total_time_step):
			return False;

		return True;

	def LegalActions(self, state):
		#ALREADY implemented, hopefully no need to change.
		# return an array of legal actions
		if(self.StatesLoaded == False):
			print("LegalActions in MFM Paper: transitionmatrix not set up")
			return [];

		if(state.time == self.total_time_step):
			return [action_paper("EXIT")]

		action_list = []
		state_str = state.GetStringVal()
		if(state_str not in self.TransitionMatrix):
			print("No required state found in MFM Paper's transitionmatrix")
			return action_list
		for action_str in self.TransitionMatrix[state_str]:
			action_list.append(action_paper(action_str))

		return action_list

	def NextState_states_probs(self, state, action):
		#ALREADY implemented, hopefully no need to change.
		# return an array of all the possible next states
		# and the array of corresponding possibilitie
		if(self.StatesLoaded == False):
			print("NextState_states_probs in MFM Paper: transitionmatrix not set up")
			return [], [];

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

	def plot_policy(self, policy_table):
		# for results demonstration. No need to implement this funciton yet.
		for key, value in policy_table.items():
			print(self.State_Table[key].index , key, ":", value)
		return

	def plot_V_values(self, V_value_table):
		# for results demonstration. No need to implement this funciton yet.
		for key, value in V_value_table.items():
			print(self.State_Table[key].index , key, ":", value)
		#self.print_transitionmatrix();
		return;

	def plot_Q_values(self, Q_value_table):
		# for results demonstration. No need to implement this funciton yet.
		return;

	def print_transitionmatrix(self, Q_value_table, V_value_table):
		#self.TransitionMatrix[this_state_str][this_action_str][next_state_str][prob]
		for i in self.TransitionMatrix.keys():
			print(self.State_Table[i].index, i);
			for j in self.TransitionMatrix[i].keys():
				if(j == "EXIT"):
					continue;
				print('   ', j, Q_value_table[i][j]);
				for k in self.TransitionMatrix[i][j].keys():
					print('	  ', round(self.TransitionMatrix[i][j][k], 5), \
						'\t', self.State_Table[k].index, '\t' , k, '\t', V_value_table[k])
		return;
