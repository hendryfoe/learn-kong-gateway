import { Application, Router, Status } from 'oak/mod.ts';
import { cloneDeep, sleep } from '../utils/util.ts';
import { errorHandlerMiddleware } from '../middlewares/error-handler.middleware.ts';
import { logResponseTimeMiddleware, setXResponseTimeMiddleware } from '../middlewares/x-response-time.middleware.ts';
import { users } from '../app-auth/app-auth.ts';

const router = new Router();
router
  .get('/users', (context) => {
    // await sleep(2000)
    // context.throw(Status.BadRequest, 'Unauthorized');
    context.response.body = Array.from(users.values()).map((user) => {
      const filteredUser = cloneDeep(user);
      delete filteredUser.password;
      return filteredUser;
    });
  })
  .get('/users/:id', (context) => {
    const id = context?.params?.id;
    if (users.has(id)) {
      const user = cloneDeep(users.get(id));
      delete user.password;
      context.response.body = user;
      return;
    }

    context.throw(Status.NotFound, 'Not Found');
  })
  .get('/private/users', (context) => {
    context.response.body = Array.from(users.values()).map((user) => {
      const filteredUser = cloneDeep(user);
      delete filteredUser.password;
      return filteredUser;
    });
  })
  .get('/private/users/:id', (context) => {
    const id = context?.params?.id;
    if (users.has(id)) {
      const user = cloneDeep(users.get(id));
      delete user.password;
      context.response.body = user;
      return;
    }

    context.throw(Status.NotFound, 'Not Found');
  });

const apps = [
  new Application(),
  new Application()
];

apps.forEach((app, index) => {
  app.addEventListener('listen', () => {
    console.log(`[Ready] One_LB-${index + 1}`)
  })
  app.use(logResponseTimeMiddleware);
  app.use(setXResponseTimeMiddleware);
  app.use(errorHandlerMiddleware(`One_LB-${index + 1}`));
  app.use(router.routes());
  app.use(router.allowedMethods());
})

export { apps };
