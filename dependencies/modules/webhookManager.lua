local webhookManager = {
    webhookTemplate = { ["embeds"] = {{}} };
    webhookCache = { ["embeds"] = {{}} };
    webhook = "";
}

--// [[ SERVICES ]] \\--
local httpService = game:GetService("HttpService")

--// [[ FUNCTIONS ]] \\--

-- private functions
local function colorToDecimal(color: Color3)
    local r = math.floor(color.R * 255)
    local g = math.floor(color.G * 255)
    local b = math.floor(color.B * 255)
    return (r * 65536) + (g * 256) + b
end

-- public functions
function webhookManager:setTitle(title: string)
    self.webhookCache.embeds[1].title = title
end

function webhookManager:setThumbnail(thumbnail : string)
    self.webhookCache.embeds[1].thumbnail = {
        url = thumbnail
    }
end

function webhookManager:setTimestamp(time)
    self.webhookCache.embeds[1].timestamp = time
end

function webhookManager:setColor(color : Color3)
    self.webhookCache.embeds[1].color = colorToDecimal(color)
end

function webhookManager:setFields(fields)
    self.webhookCache.embeds[1].fields = {}
    for index=1, #fields do
        table.insert(self.webhookCache.embeds[1].fields, fields[index])
    end
end

function webhookManager:setWebhook(webhook : string)
    self.webhook = webhook
end

function webhookManager:setWebhookTemplate(webhookTemplate : {})
    self.webhookTemplate = webhookTemplate
    self.webhookCache = self.webhookTemplate
end

function webhookManager:Fire()
    local attempts = 0;

    repeat
        local success, response = pcall(request, {
            Url = self.webhook,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = httpService:JSONEncode(self.webhookCache)
        })

        if response.Success == false then
            warn(response.StatusCode, response.StatusMessage)
            attempts += 1;
        end

        if attempts == 5 then break end;
        
        task.wait(1)
    until response.Success

    -- reset the webhook to defaults
    self.webhookCache = self.webhookTemplate
end


return webhookManager