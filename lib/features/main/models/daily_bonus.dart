const Map<String, dynamic> dailyBonusData = {
  "dailyWisdom": {
    "title": "Chicken Coop Daily Financial Wisdom",
    "subtitle": "31 Farm-Inspired Proverbs & Tips",
    "description": "Practical barnyard wisdom for modern nest-egg building",
    "version": "1.0",
    "totalTips": 31
  },
  "proverbs": [
    {"day": 1, "title": "The Patient Nest", "proverb": '''A nest isn’t filled in a day, but one egg at a time.''', "tip": '''Small, consistent deposits grow your savings. Even tiny daily transfers add up to a hearty clutch.'''},
    {"day": 2, "title": "The Wise Feeder", "proverb": "The foolish hen pecks at wants; the wise one saves for needs.", "tip": "Before you spend, ask: is this feed or fluff? Prioritize true needs and your coop stays secure."},
    {"day": 3, "title": "The Kept Kernel", "proverb": "A kernel saved today is warmth in the coop tomorrow.", "tip": "Every small amount unspent becomes cushion for future chances or surprises."},
    {"day": 4, "title": "The Shiny Trap", "proverb": "Not every shiny tool belongs in your shed.", "tip": "Skip too-good-to-be-true schemes. Real wealth grows like crops—steady and seasonal."},
    {"day": 5, "title": "The Tight Trough", "proverb": "Better a small trough that holds feed than a big one that leaks.", "tip": "A modest budget you keep beats an ambitious one you break. Start small, build wins."},
    {"day": 6, "title": "The Open Wing", "proverb": "Share your grain, but not from an empty bin.", "tip": "Give when you can, and first ensure your own safety net so you can keep helping."},
    {"day": 7, "title": "The Double Count", "proverb": "Count your coins twice, spend them once.", "tip": "Track expenses closely. Clarity over outflows is the first step to control."},
    {"day": 8, "title": "The Early Rooster", "proverb": "The early rooster finds the fairest prices.", "tip": "Plan purchases ahead and compare. Rushed pecking leads to overspending."},
    {"day": 9, "title": "The Solid Coop", "proverb": "A coop on firm posts outlasts one on soft mud.", "tip": "Build on basics: spend less than you earn, save routinely, and avoid high-cost debt."},
    {"day": 10, "title": "The Hidden Feed", "proverb": "Good grain often hides in plain sight.", "tip": "Hunt quiet savings: brew at home, walk short trips, repair before replacing."},
    {"day": 11, "title": "The Planted Seed", "proverb": "Plant a seed today; shade comes to tomorrow’s flock.", "tip": "Invest early, even small amounts. Time and compounding do the heavy lifting."},
    {"day": 12, "title": "The Heavy Borrow", "proverb": "Borrowed feed weighs heavier than a full sack.", "tip": "Debt limits freedom. Avoid it when possible; pay it down fast when needed."},
    {"day": 13, "title": "The Weather Eye", "proverb": "Save in clear skies; storms always visit the farm.", "tip": "Build an emergency fund in good times—surprises are as certain as spring rain."},
    {"day": 14, "title": "The Neighbor’s Field", "proverb": "The neighbor’s pasture may look greener, but your rows still need tending.", "tip": "Ignore comparison. Focus on your goals, your soil, your progress."},
    {"day": 15, "title": "The Sturdy Tool", "proverb": "Buy once, mend rarely—quality beats quantity.", "tip": "Pay more for durable goods when it lowers long-term cost and hassle."},
    {"day": 16, "title": "The Marked Calendar", "proverb": "A dream without a chore list never leaves the barn.", "tip": "Set clear, measurable money goals with dates. Purpose fuels consistency."},
    {"day": 17, "title": "The Daily Peck", "proverb": "Good habits multiply like chicks in spring.", "tip": "Automate bills and savings. Systems beat willpower on busy days."},
    {"day": 18, "title": "The Calm Roost", "proverb": "When the market flaps its wings, keep your talons steady.", "tip": "Ignore short-term noise. Stick to your long-term plan and allocation."},
    {"day": 19, "title": "The Curious Chick", "proverb": "A learning hen finds more grain.", "tip": "Keep studying personal finance. Knowledge compounds like interest."},
    {"day": 20, "title": "The Full Coop", "proverb": "The richest farmer values what’s already in the barn.", "tip": "Practice gratitude to resist lifestyle creep and impulse buys."},
    {"day": 21, "title": "The Storm Shield", "proverb": "Three months of feed keeps the flock calm through long rains.", "tip": "Aim for 3–6 months of expenses saved to soften job or health shocks."},
    {"day": 22, "title": "The Slow Brew", "proverb": "Good broth and good wealth both take time.", "tip": "Expect slow, steady growth. Patience prevents costly detours."},
    {"day": 23, "title": "The True Cost", "proverb": "A cheap rake that breaks costs more than a sturdy one that lasts.", "tip": "Consider total ownership cost—repairs, time, and lifespan—not just price."},
    {"day": 24, "title": "The Invisible Bin", "proverb": "The best savings bin is the one you forget you filled.", "tip": "Automate transfers right after payday. Money unseen is money unspent."},
    {"day": 25, "title": "The Bigger Barn", "proverb": "As the barn grows, don’t let the feed bill outrun it.", "tip": "When income rises, hold spending flat. Bank the difference."},
    {"day": 26, "title": "The Many Baskets", "proverb": "Don’t keep every egg in one basket—no matter how shiny.", "tip": "Diversify across assets and accounts to reduce risk."},
    {"day": 27, "title": "The Honest Harvest", "proverb": "Grain you grow shines brighter than grain you stumble upon.", "tip": "Rely on steady work, saving, and investing—not speculation."},
    {"day": 28, "title": "The Tiny Leaks", "proverb": "Drips in the trough can empty the tank.", "tip": "Review subscriptions and fees. Small leaks sink big plans over time."},
    {"day": 29, "title": "The Future Farmer", "proverb": "Farm today with tomorrow’s flock in mind.", "tip": "Choose actions your future self would thank you for. Think in seasons, not days."},
    {"day": 30, "title": "The Fence Line", "proverb": "Walk the fence—lean too far either way and you’ll tumble.", "tip": "Balance. Don’t be overly strict or loose with spending. Adjust, don’t abandon."},
    {"day": 31, "title": "The Enough Test", "proverb": "The hen who knows ‘enough’ always has enough.", "tip": "Define sufficiency. Contentment frees cash for goals and gives peace of mind."}
  ],
  "usage": {
    "delivery": "Display one proverb per day based on calendar date (day 1-31)",
    "rotation": "After day 31, cycle back to day 1 for months with fewer days",
    "format": "Present both the proverb and tip to the user",
    "timing": "Ideal for morning notifications or app opening"
  }
};
