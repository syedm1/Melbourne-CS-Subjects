# search.py
# ---------
# Licensing Information:  You are free to use or extend these projects for
# educational purposes provided that (1) you do not distribute or publish
# solutions, (2) you retain this notice, and (3) you provide clear
# attribution to UC Berkeley, including a link to http://ai.berkeley.edu.
# 
# Attribution Information: The Pacman AI projects were developed at UC Berkeley.
# The core projects and autograders were primarily created by John DeNero
# (denero@cs.berkeley.edu) and Dan Klein (klein@cs.berkeley.edu).
# Student side autograding was added by Brad Miller, Nick Hay, and
# Pieter Abbeel (pabbeel@cs.berkeley.edu).


"""
In search.py, you will implement generic search algorithms which are called by
Pacman agents (in searchAgents.py).
"""

import util
class SearchProblem:
    """
    This class outlines the structure of a search problem, but doesn't implement
    any of the methods (in object-oriented terminology: an abstract class).

    You do not need to change anything in this class, ever.
    """

    def getStartState(self):
        """
        Returns the start state for the search problem.
        """
        util.raiseNotDefined()

    def isGoalState(self, state):
        """
          state: Search state

        Returns True if and only if the state is a valid goal state.
        """
        util.raiseNotDefined()

    def getSuccessors(self, state):
        """
          state: Search state

        For a given state, this should return a list of triples, (successor,
        action, stepCost), where 'successor' is a successor to the current
        state, 'action' is the action required to get there, and 'stepCost' is
        the incremental cost of expanding to that successor.
        """
        util.raiseNotDefined()

    def getCostOfActions(self, actions):
        """
         actions: A list of actions to take

        This method returns the total cost of a particular sequence of actions.
        The sequence must be composed of legal moves.
        """
        util.raiseNotDefined()


def tinyMazeSearch(problem):
    """
    Returns a sequence of moves that solves tinyMaze.  For any other maze, the
    sequence of moves will be incorrect, so only use this for tinyMaze.
    """
    return  [s, s, w, s, w, w, s, w]


def depthFirstSearch(p):
    stack = util.Stack()
    cur = (p.getStartState(),'start')
    visited = set([cur[0]])
    while (not p.isGoalState(cur[0])):
        flag = True
        for c in p.getSuccessors(cur[0]):
            if c[0] not in visited:
                visited.add(c[0])
                stack.push(cur)
                flag = False
                break
        cur = stack.pop() if flag else c
    stack.push(cur)
    res = [c[1] for c in stack.list][1:]
    return res


def breadthFirstSearch(p):
    stack = util.Queue()
    cur = [(p.getStartState(),'start')]
    visited = set(cur[0])
    while (not p.isGoalState(cur[-1][0])):
        for c in p.getSuccessors(cur[-1][0]):
            if c[0] not in visited:
                visited.add(c[0])
                d = cur[:]
                d.append(c)
                stack.push(d)
        cur = stack.pop()
    res = [c[1] for c in cur][1:]
    return res

def uniformCostSearch(p):
    stack = util.Stack()
    cur = (p.getStartState(),'start')
    visited = set([cur[0]])
    while (not p.isGoalState(cur[0])):
        flag = True
        best = ('','',float('inf'))
        for c in p.getSuccessors(cur[0]):
            if (c[0] not in visited) and (c[2] < best[2]):
                best = c
                flag = False
        if flag:
            cur = stack.pop()
        else:
            visited.add(best[0])
            stack.push(cur)
            cur = best
    stack.push(cur)
    res = [c[1] for c in stack.list][1:]
    print res
    return res

def nullHeuristic(state, problem=None):
    """
    A heuristic function estimates the cost from the current state to the nearest
    goal in the provided SearchProblem.  This heuristic is trivial.
    """
    return 0

def aStarSearch(problem, heuristic=nullHeuristic):
    """Search the node that has the lowest combined cost and heuristic first."""
    "*** YOUR CODE HERE ***"
    util.raiseNotDefined()


# Abbreviations
bfs = breadthFirstSearch
dfs = depthFirstSearch
astar = aStarSearch
ucs = uniformCostSearch
