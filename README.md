
# 🦖 Trixie & Rex: Perkmaster's Dungeon (Dino-Apocalypse)

A cute, hand-drawn, simple 2D survival/arcade game built entirely in **Processing (Java)**. Take control of Trixie, manage your items, survive a scaling difficulty meter, and prove Rex wrong by blasting past Level 3!

<img width="1184" height="699" alt="Screenshot 2026-06-23 at 9 15 18 PM" src="https://github.com/user-attachments/assets/257dda26-f702-49de-8135-2040da4f67b9" />

---

## 📖 The Story
> **Rex:** *"You ready to lose again, Trixie? Last time you barely made it past Level 3."*  
> **Trixie:** *"That was because someone distracted me by yelling 'Incoming meteor!' every two seconds..."*

The dino-apocalypse is here! Armed with snacks, focus, and a magical blaster, you must weave through waves of basic enemies and ruthless bosses. Collect items, stay alive, and watch out for the scaling difficulty meter!

---

## 🎮 Key Features & Mechanics

* **🎨 Handdrawn Style:** Utilizes custom-layered static frames (`front_layer.png`, `front_layer_back.png`) and stylized glowing animations (`glow_y`, `glow_r`, `glow_b`) to create a hand-drawn, cozy aesthetic.
* **⚡ Dynamic Difficulty Scaling:** The game tracks your survival! Every 1.5 seconds (90 frames), the `difficultyLevel` bar drops, forcing enemies to spawn significantly faster. 
* **👾 Enemy Types:** 
  * **Basic Enemy:** Common threats that drop items at standard rates.
  * **Boss Enemy:** High-health targets that spawn as the difficulty ramps up. They move faster and have **double the item drop rate**!
* **🎒 Consumable Inventory System:**
  * **❤️ Health Potions (Key 1):** Instantly restores up to 50 HP.
  * **🧪 Mana Potions (Key 2):** Instantly fully charges your stamina/mana to 100%.
  * **🍬 Candy (Key 3):** *The ultimate survival snack.* Triggers a 6-second superpower state that passively regenerates health/stamina over time and **doubles your damage output**!

---

## ⌨️ Controls & Input

| Key / Action | In-Game Command |
| :--- | :--- |
| **`W` `A` `S` `D`** / **Arrows** | Move Character |
| **`SHIFT`** | Sprint |
| **`Left Mouse Click`** | Shoot Blaster (Advance dialogue in intro) |
| **`1`** | Consume Health Potion |
| **`2`** | Consume Mana Potion |
| **`3`** | Consume Candy |

---

## 🚀 How to Run

1. Download and install [Processing IDE](https://processing.org/).
2. Open a PDE file and CTRL+R

<img width="1027" height="693" alt="Screenshot 2026-06-23 at 9 08 05 PM" src="https://github.com/user-attachments/assets/e8719d8e-a913-40ce-9be5-a964a1cf803b" />
<img width="1028" height="696" alt="Screenshot 2026-06-23 at 9 06 05 PM" src="https://github.com/user-attachments/assets/bdc36b94-8c48-4f51-995d-fa166966759d" />
https://github.com/user-attachments/assets/77246d30-4438-402f-ac61-d0621c1c5212

