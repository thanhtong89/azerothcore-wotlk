#pragma once
#include "PassTroughStrategy.h"

namespace BotAI
{
    class DuelStrategy : public PassTroughStrategy
    {
    public:
        DuelStrategy(PlayerbotAI* ai);

    public:
        virtual void InitTriggers(std::list<TriggerNode*> &triggers);
        virtual string getName() { return "duel"; }
    };
}
