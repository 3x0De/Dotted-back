from Script.Dot import *

def Connection (username, mdp):
    return GetMdp(username) == hash(mdp)

def Session(Ip):
    for user in GetIpIdAllList():
        print(user)
        if type(user[0]) == list and ipaddress.IPv4Address(Ip) in user[0]:
            return user[1]
