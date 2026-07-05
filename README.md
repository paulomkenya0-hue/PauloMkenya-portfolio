# Paulo Mkenya — Portfolio (Vite + React + Supabase)

Tovuti hii ni toleo la kweli, linalowezekana ku-deploy la portfolio yako — data (miradi, blog, ujumbe) inahifadhiwa kwenye **database halisi ya Supabase (Postgres)**, na admin inatumia **Supabase Auth** halisi (siyo password iliyowekwa kwenye msimbo).

## Hatua 1 — Andaa Database ya Supabase (una akaunti tayari ✅)

1. Nenda [supabase.com/dashboard](https://supabase.com/dashboard) → fungua project yako (au tengeneza mpya, bure).
2. Upande wa kushoto, bofya **SQL Editor** → **New query**.
3. Fungua faili `supabase/schema.sql` iliyomo humu, nakili yote, bandika kwenye SQL Editor, bofya **Run**.
   - Hii itaunda tables zote (projects, posts, comments, messages, settings) na sheria za usalama (RLS).
4. Nenda **Authentication → Users → Add user** → weka barua pepe na password utakayotumia wewe (Paulo) kuingia kama admin. Mfano: `paulo@mkenya.dev` / password yenye nguvu.
5. Nenda **Project Settings → API** → nakili:
   - `Project URL`
   - `anon public` key

## Hatua 2 — Weka Environment Variables

1. Nakili faili `.env.example` kuwa `.env`.
2. Jaza:
   ```
   VITE_SUPABASE_URL=https://xxxxxxxx.supabase.co
   VITE_SUPABASE_ANON_KEY=eyJhbGciOi...
   ```

## Hatua 3 — Jaribu Kwenye Kompyuta Yako (hiari)

```bash
npm install
npm run dev
```
Fungua `http://localhost:5173` kwenye kivinjari.

## Hatua 4 — Weka Msimbo kwenye GitHub

1. Tengeneza repository mpya kwenye [github.com](https://github.com) (bure).
2. Pakia folder hii nzima (isipokuwa `.env` — usiipakie hadharani, ina siri).
   ```bash
   git init
   git add .
   git commit -m "Paulo Mkenya portfolio"
   git branch -M main
   git remote add origin https://github.com/JINA-LAKO/paulo-portfolio.git
   git push -u origin main
   ```

## Hatua 5 — Deploy Bure kwenye Vercel

1. Nenda [vercel.com](https://vercel.com) → **Sign up** kwa akaunti ya GitHub (bure).
2. **Add New Project** → chagua repository uliyopakia.
3. Vercel itagundua kiotomatiki kuwa ni mradi wa Vite.
4. Kabla ya "Deploy", fungua **Environment Variables** ongeza:
   - `VITE_SUPABASE_URL`
   - `VITE_SUPABASE_ANON_KEY`
   (thamani zilezile ulizoweka kwenye `.env`)
5. Bofya **Deploy**. Baada ya dakika chache utapata kiungo kama `paulo-portfolio.vercel.app` — tovuti yako iko hewani, bure.

## Hatua 6 — Unganisha Domain Yako

Ukishanunua domain (Namecheap, Cloudflare, n.k.):
1. Kwenye Vercel project yako → **Settings → Domains** → andika domain yako, bofya **Add**.
2. Vercel itakupa maelekezo ya DNS (kawaida rekodi ya aina `A` au `CNAME`).
3. Nenda kwenye dashibodi ya usajili wa domain yako (Namecheap/Cloudflare) → **DNS settings** → ongeza rekodi hizo.
4. Subiri dakika 10–60 (wakati mwingine hadi masaa 24) DNS ienee — kisha domain yako itaonyesha tovuti moja kwa moja, bure kabisa (Vercel hailipishi kwa domain za kibinafsi).

## Jinsi ya Kutumia Baadaye

- **Kuongeza/kuhariri miradi na blog**: nenda `/admin` kwenye tovuti yako, ingia na barua pepe/password uliyotengeneza kwenye Supabase, tumia dashibodi.
- **Ujumbe wa wateja**: wanapotuma fomu ya Mawasiliano, ujumbe unaingia moja kwa moja kwenye database — utaonekana kwenye tab ya "Ujumbe" ukiwa umeingia kama admin, popote ulipo.
- **Ukibadilisha msimbo**: `git push` tena — Vercel ita-deploy upya kiotomatiki.

## Usalama

- Nenosiri la admin halijawekwa kwenye msimbo — linahifadhiwa salama na Supabase Auth.
- Kila jedwali lina Row Level Security (RLS): wageni wanaweza kusoma miradi/blogu iliyochapishwa na kutuma ujumbe/maoni tu; kuhariri/kufuta kunahitaji kuingia kama admin.
- `.env` yenye funguo zako haipaswi kupakiwa kwenye GitHub ya hadhara — tumia Environment Variables za Vercel badala yake.
