#!/usr/bin/env python

import sys
import asyncio
import importlib
import logging

import occi
import occi_demo_resnet
import occi_default
import occi_movement
import occi_seeing
import occi_training

# TODO scan installed packages to identify personalities as alternative approach
occi.known_modules = [occi_demo_resnet, occi_default, occi_movement, occi_seeing, occi_training]

# Watch and reload occi module
occi.watch_code_update(lambda signum, frame: importlib.reload(occi))

sys.path.append("/tmp/home")

async def main():
    # print("Active personality is", occi.current_state.active_personality.name)
    occi.current_state.perceptive_iteration()

    # TODO if error, slow down
    await asyncio.sleep(0.3)
    asyncio.ensure_future(main())


# TODO on exit clear the screen and say bye.

def main():
    logging.basicConfig(
        format='%(asctime)s %(levelname)s %(message)s', 
        level=logging.DEBUG
    )

    print("Main start.")
    asyncio.set_event_loop(asyncio.new_event_loop())
    occi.ensure_future_input()
    asyncio.ensure_future(main())

    loop = asyncio.get_event_loop()
    loop.run_forever()


if __name__ == "__main__":
    main()