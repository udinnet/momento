import { Actor, HttpAgent } from '@dfinity/agent';
import { idlFactory as momento_idl, canisterId as momento_id } from 'dfx-generated/momento';

const agent = new HttpAgent();
const momento = Actor.createActor(momento_idl, { agent, canisterId: momento_id });

document.getElementById("clickMeBtn").addEventListener("click", async () => {
  const name = document.getElementById("name").value.toString();
  const greeting = await momento.greet(name);

  document.getElementById("greeting").innerText = greeting;
});
