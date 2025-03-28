//
//  jit.h
//  StikJIT
//
//  Created by Stephen on 3/27/25.
//

// jit.h
#ifndef JIT_H
#define JIT_H
#include "idevice.h"

typedef void (^LogFuncC)(const char* message, ...);
int debug_app(TcpProviderHandle* provider, const char *bundle_id, LogFuncC logger);

#endif /* JIT_H */
