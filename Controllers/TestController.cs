using System;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;

namespace Elastic.Apm.Test.Api.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class TestController : ControllerBase
    {
        private readonly ILogger<TestController> _logger;
        public TestController(ILogger<TestController> logger)
        {
            _logger = logger;
        }

        Random _rand = new Random();

        [HttpGet]
        public async Task<ActionResult<string>> AmIAlive()
        {
            var delay = _rand.Next(500, 1500);
            
            _logger.LogInformation($"Waiting {delay} milliseconds before returning.");

            await Task.Delay(delay);

            _logger.LogInformation($"Waited {delay} milliseconds before returning.");

            return Ok("You betcha!");
        }

        [HttpPost("exception")]
        public async Task<ActionResult<string>> ThrowSomethingInteresting()
        {
            var delay = _rand.Next(500, 1500);
            
            _logger.LogCritical($"Waiting {delay} milliseconds before throwing.");

            await Task.Delay(delay);

            _logger.LogCritical($"Waited {delay} milliseconds before throwing.");

            throw new InvalidOperationException("no, sir");
        }
    }
}
