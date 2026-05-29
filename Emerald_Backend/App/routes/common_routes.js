let express = require("express");
let router = express.Router();
router.use(express.json()); // IMPORTANT: parse JSON body

router.get("/", (req, res) => {
    res.json({
        status: "success",
        message: "API router is working"
    });
});



router.post('/prompt', (req, res) => {
    const { user_input, tasks } = req.body;

    console.log("User Input:", user_input);
    console.log("Tasks:", tasks);

    res.json({
        status: "success",
        message: "Prompt received",
        received: {
            user_input,
            tasks
        }
    });
});


module.exports = router;