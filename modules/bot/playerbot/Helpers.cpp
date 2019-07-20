#include "../pchdef.h"
#include "playerbot.h"
#include <algorithm>
#include <functional>
#include <cctype>
#include <locale>

// store absolute bit position for first rank for talent inspect
static uint32 sTalentTabPages[MAX_CLASSES][3];
static bool sTalentTabPagesInitialized;


// prepare fast data access to bit pos of talent ranks for use at inspecting
void initializeTalentTabPages() {
    if (sTalentTabPagesInitialized) {
        return;
}
		// now have all max ranks (and then bit amount used for store talent ranks in inspect)
                for (uint32 talentTabId = 1; talentTabId < sTalentTabStore.GetNumRows(); ++talentTabId)
		{
                        TalentTabEntry const* talentTabInfo = sTalentTabStore.LookupEntry(talentTabId);
                        if (!talentTabInfo)
                            continue;
			// prevent memory corruption; otherwise cls will become 12 below
			if ((talentTabInfo->ClassMask & CLASSMASK_ALL_PLAYABLE) == 0)
			continue;

			// store class talent tab pages
			for (uint32 cls = 1; cls < MAX_CLASSES; ++cls)
			if (talentTabInfo->ClassMask & (1 << (cls - 1)))
				sTalentTabPages[cls][talentTabInfo->tabpage] = talentTabInfo->TalentTabID;
		}	

		sTalentTabPagesInitialized = true;
}

namespace BotAI {
    uint32 const* GetTalentTabPages(uint8 cls)
    {
        initializeTalentTabPages();
        return sTalentTabPages[cls];
    }
}

vector<string>& split(const string &s, char delim, vector<string> &elems)
{
    stringstream ss(s);
    string item;
    while(getline(ss, item, delim))
    {
        elems.push_back(item);
    }
    return elems;
}


vector<string> split(const string &s, char delim)
{
    vector<string> elems;
    return split(s, delim, elems);
}

char *strstri(const char *haystack, const char *needle)
{
    if ( !*needle )
    {
        return (char*)haystack;
    }
    for ( ; *haystack; ++haystack )
    {
        if ( tolower(*haystack) == tolower(*needle) )
        {
            const char *h = haystack, *n = needle;
            for ( ; *h && *n; ++h, ++n )
            {
                if ( tolower(*h) != tolower(*n) )
                {
                    break;
                }
            }
            if ( !*n )
            {
                return (char*)haystack;
            }
        }
    }
    return 0;
}



uint64 extractGuid(WorldPacket& packet)
{
    uint8 mask;
    packet >> mask;
    uint64 guid = 0;
    uint8 bit = 0;
    uint8 testMask = 1;
    while (true)
    {
        if (mask & testMask)
        {
            uint8 word;
            packet >> word;
            guid += (word << bit);
        }
        if (bit == 7)
            break;
        ++bit;
        testMask <<= 1;
    }
    return guid;
}

std::string &ltrim(std::string &s) {
        s.erase(s.begin(), std::find_if(s.begin(), s.end(), std::not1(std::ptr_fun<int, int>(std::isspace))));
        return s;
}

std::string &rtrim(std::string &s) {
        s.erase(std::find_if(s.rbegin(), s.rend(), std::not1(std::ptr_fun<int, int>(std::isspace))).base(), s.end());
        return s;
}

std::string &trim(std::string &s) {
        return ltrim(rtrim(s));
}

