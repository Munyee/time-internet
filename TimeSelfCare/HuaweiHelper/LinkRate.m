//
//  LinkRate.m
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 25/05/2021.
//  Copyright © 2021 Apptivity Lab. All rights reserved.
//

#import "LinkRate.h"
#include <ifaddrs.h>
#include <net/if.h>

@implementation LinkRate 

+(double)getRouterLinkSpeed
{
    BOOL   success;
    struct ifaddrs *addrs;
    const struct ifaddrs *cursor;
    const struct if_data *networkStatisc;
    
    double linkSpeed = 0;
    
    NSString *name = [[NSString alloc] init];
    
    success = getifaddrs(&addrs) == 0;
    if (success)
    {
        cursor = addrs;
        while (cursor != NULL)
        {
            name=[NSString stringWithFormat:@"%s",cursor->ifa_name];
            
            if (cursor->ifa_addr->sa_family == AF_LINK)
            {
                if ([name hasPrefix:@"en"])
                {
                    networkStatisc = (const struct if_data *) cursor->ifa_data;
                    linkSpeed = networkStatisc->ifi_baudrate;
                    break;
                }
            }
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addrs);
    }
    
    return linkSpeed;
}


@end

