import { Application, Router, Status } from 'oak/mod.ts';

import { cloneDeep, signJWT, verifyJWT } from '../utils/util.ts';
import { errorHandlerMiddleware } from '../middlewares/error-handler.middleware.ts';
import { logResponseTimeMiddleware, setXResponseTimeMiddleware } from '../middlewares/x-response-time.middleware.ts';

interface User {
  name: string;
  gender: string;
  email: string;
  password: string;
}

export const users = new Map<string, User>();
users
  .set('1', {
    name: 'John Doe',
    gender: 'male',
    email: 'johndoe@test.com',
    password: 'johndoe@test.com',
  })
  .set('2', {
    name: 'Bumble Bee',
    gender: 'male',
    email: 'bumblebee@test.com',
    password: 'bumblebee@test.com',
  })
  .set('3', {
    name: 'Optimus Prime',
    gender: 'male',
    email: 'optimusprime@test.com',
    password: 'optimusprime@test.com',
  });

const router = new Router();
router
  .post('/login', async (context) => {
    console.log('[POST] Login');
    if (!context.request.hasBody) {
      context.throw(Status.BadRequest, 'Bad Request');
    }
    const body = context.request.body();

    if (body.type === 'json') {
      const payload = await (body.value as Promise<Partial<User>>).catch(() => {
        context.throw(Status.BadRequest, JSON.stringify({ message: 'Bad Request' }));
        return;
      }) as { email: string; password: string };

      for (const [_, value] of users.entries()) {
        if (value.email === payload.email && value.password === payload.password) {
          // console.log('payload', payload);
          const sanitizedPayload = cloneDeep(payload);
          delete sanitizedPayload.password;

          const token = await signJWT(sanitizedPayload);

          context.response.body = { accessToken: token };

          return;
        }
      }
    }
    context.throw(Status.BadRequest, JSON.stringify({ message: 'Bad Request' }));
  });

const app = new Application();
app.addEventListener('listen', () => {
  console.log(`[Ready] App-Auth`)
})

app.use(logResponseTimeMiddleware);
app.use(setXResponseTimeMiddleware);
app.use(errorHandlerMiddleware('Auth'));
app.use(router.routes());
app.use(router.allowedMethods());

export { app };
