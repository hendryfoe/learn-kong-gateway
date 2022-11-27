import { Application, Router } from 'oak/mod.ts';
import { errorHandlerMiddleware } from '../middlewares/error-handler.middleware.ts';
import { logResponseTimeMiddleware, setXResponseTimeMiddleware } from '../middlewares/x-response-time.middleware.ts';

const cakes = new Map();
cakes
  .set('1', {
    name: 'Banana Cake',
    sugar: 70,
    price: 3.5,
  })
  .set('2', {
    name: 'Lemon Yoghurt',
    sugar: 20,
    price: 2,
  })
  .set('3', {
    name: 'Red Velvet',
    sugar: 50,
    price: 5,
  });

const router = new Router();
router
  .get('/cakes', (context) => {
    context.response.body = Array.from(cakes.values());
  })
  .get('/cakes/:id', (context) => {
    const id = context?.params?.id;
    if (cakes.has(id)) {
      context.response.body = cakes.get(id);
      return;
    }

    context.response.status = 404;
    context.response.body = { message: 'Not Found' };
  });

const app = new Application();
app.addEventListener('listen', () => {
  console.log(`[Ready] App-Four`)
})

app.use(logResponseTimeMiddleware);
app.use(setXResponseTimeMiddleware);
app.use(errorHandlerMiddleware('Four'));
app.use(router.routes());
app.use(router.allowedMethods());

export { app };
