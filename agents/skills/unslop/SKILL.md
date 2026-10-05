---
name: unslop
description: Cut AI tells from any writing. Must always apply.
---

# Unslop

Edit text to remove AI patterns and add human voice.

## Process

1. Scan for the patterns below.
2. Rewrite. Preserve meaning, match intended tone.
3. Add soul (see next section).
4. Self-audit: "What makes this obviously AI generated?" Fix remaining tells.

## Adding soul

Removing patterns is half the job. Sterile, voiceless writing is just as obvious.

- **Have opinions.** React to facts instead of neutrally listing pros and cons.
- **Vary rhythm.** Short sentences. Then longer ones that take their time.
- **Use "I" when it fits.** First person isn't unprofessional.
- **Be specific.** Not "this is concerning" but "there's something unsettling about agents churning away at 3am".

## Patterns to detect and fix

### Language

1. **AI vocabulary.** Additionally, crucial, delve, enduring, enhance, ensure, fostering, garner, interplay, intricate, landscape (abstract), pivotal, robust, seamless, showcase, testament, underscore, vibrant. Replace with plain words.
2. **Fancy ways to say "is".** "serves as", "stands as", "boasts", "features". Just say "is" or "has".
3. **"Not just X, but Y."** State the point directly instead.
4. **Rule of three.** Forcing ideas into groups of three. Use the natural number.
5. **Superficial -ing phrases.** "highlighting...", "ensuring...", "reflecting...", "allowing...". Delete or expand with the real fact.
6. **Vague attributions.** "Experts believe", "it is generally agreed". Name the source or delete.

### Style

7. **Em dash overuse.** Avoid em dashes entirely. Use periods or commas only (no parentheses, no en dashes, no hyphen-as-dash substitutes). Reaching for parentheses instead just trades one tell for another. If a thought needs separation, end the sentence or use a comma.
8. **Colon overuse.** Colons are fine before a list or example. Not as mid-sentence connectors. "If you're coming from traditional automation: instead of registering event handlers, you describe conditions" adds nothing with the colon. Rewrite to let the point stand on its own.
9. **Boldface overuse.** Don't bold every proper noun or acronym.
10. **Inline-header lists.** The tell is a bold label and colon that restates the line: "**Performance:** Performance improved...". Convert those to prose. A bold lead-in that ends in a period, names the item, and is followed by genuinely new detail ("**Schema in TypeScript.** Tables live in one file.") is fine, not a tell.
11. **Title case headings.** Use sentence case.
12. **Decorative emojis.** Remove from headings and bullets.
13. **Curly quotes.** Replace with straight quotes.

### Communication artifacts

14. **Chatbot phrases.** "I hope this helps!", "Let me know if...", "Of course!", "Certainly!", "Found the smoking gun!" Remove.
15. **Sycophantic tone.** "Great question! You're absolutely right!" Respond directly.
16. **Generic conclusions.** A closing paragraph that restates the sections above, or "the future looks bright". Cut it.

### Filler

17. **Filler phrases.** "In order to" becomes "To". "Due to the fact that" becomes "Because". "It is important to note that" gets deleted.
18. **Excessive hedging.** "could potentially possibly be argued that it might" becomes "may".
19. **Prefer the plain word.** "utilize" becomes "use", "leverage" becomes "use", "facilitate" becomes "help", "numerous" becomes "many", "in the event that" becomes "if".

### Jargon

20. **Abstract metaphor nouns.** Substrate, wedge, vector, locus, vantage, nexus, primitive (as noun), harness (as metaphor), surface (as in "API surface"), bedrock, scaffolding (as metaphor), modality, paradigm, gold-plating, ratchet (as metaphor), evacuate (for moving code), endgame, north star, flywheel. These read as technical but usually have a plainer concrete word. "Substrate" becomes "base". "Wedge in" becomes "add". "Gold-plating" becomes "more than the job needs". "Evacuate" becomes "move out". Pick the concrete word.

### Plain speech

21. **Say what it does, not how it feels.** "the database stays close at hand", "SQL you can read", "types that follow your schema" name a feeling. The fix names the mechanism or a number: "`.toSQL()` returns the exact string sent to the database", "a column rename fails the build". If you can't restate it as a concrete instruction, fact, or number, cut it. If the sentence could appear unchanged in another project's docs, it says nothing about this one. Cut it.
22. **Shorten or split dense sentences.** If the reader has to backtrack to parse a sentence, break it in two or drop clauses. One idea per sentence.
23. **Active voice.** Catch "is/are/was/were + past participle" and name the actor: "queries are validated" becomes "the compiler validates queries". Passive is fine only when the actor is unknown or genuinely doesn't matter.
24. **Cut adverbs, or use a stronger verb.** "runs quickly" becomes "is fast" or the number. "significantly improves" becomes the measured delta.
