import { Actor, HttpAgent } from '@dfinity/agent';
import { idlFactory as inception_idl, canisterId as inception_id } from 'dfx-generated/inception';

const agent = new HttpAgent();
const inception = Actor.createActor(inception_idl, { agent, canisterId: inception_id });

document.getElementById("clickMeBtn").addEventListener("click", async () => {
  const name = document.getElementById("name").value.toString();
  const greeting = await inception.greet(name);

  document.getElementById("greeting").innerText = greeting;
});
